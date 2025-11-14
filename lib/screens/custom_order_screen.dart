import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';
import '../models/custom_order.dart';
import 'dart:math';

class CustomOrderScreen extends StatefulWidget {
  const CustomOrderScreen({super.key});

  @override
  State<CustomOrderScreen> createState() => _CustomOrderScreenState();
}

class _CustomOrderScreenState extends State<CustomOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _order = CustomOrder();
  bool _isSubmitting = false;
  bool _hasUnsavedChanges = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _notesController = TextEditingController();

  final List<String> _ritualTypes = [
    'Daily Worship',
    'Special Occasion',
    'Personal Benefit',
    'Astrology',
  ];

  final List<String> _deities = [
    'Maa Kali',
    'Maa Tara',
    'Maa Shodashi',
    'Maa Bhuvaneshwari',
    'Maa Bagalamukhi',
    'Ram Janmabhoomi',
  ];

  final List<String> _aashirwadOptions = [
    'Extra Prasad',
    'Sacred Threads',
    'Rudraksha Beads',
    'Holy Water',
    'Kumkum',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges) {
          return await _showUnsavedChangesDialog();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Ritual Order'),
          backgroundColor: AppTheme.sacredBlue,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spaceLG),
            child: Form(
              key: _formKey,
              onChanged: () {
                setState(() {
                  _hasUnsavedChanges = true;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(),
                  const SizedBox(height: AppTheme.spaceXL),
                  _buildNameField(),
                  const SizedBox(height: AppTheme.spaceMD),
                  _buildEmailField(),
                  const SizedBox(height: AppTheme.spaceMD),
                  _buildPhoneField(),
                  const SizedBox(height: AppTheme.spaceMD),
                  _buildRitualTypeField(),
                  const SizedBox(height: AppTheme.spaceMD),
                  _buildDeityPreferences(),
                  const SizedBox(height: AppTheme.spaceMD),
                  _buildDateTimeSelection(),
                  const SizedBox(height: AppTheme.spaceMD),
                  _buildSpecialInstructions(),
                  const SizedBox(height: AppTheme.spaceMD),
                  _buildAashirwadPreferences(),
                  const SizedBox(height: AppTheme.spaceMD),
                  _buildAdditionalNotes(),
                  const SizedBox(height: AppTheme.spaceMD),
                  _buildPricingGuide(),
                  const SizedBox(height: AppTheme.spaceMD),
                  _buildProcessTimeline(),
                  const SizedBox(height: AppTheme.spaceXL),
                  _buildSubmitButton(),
                  const SizedBox(height: AppTheme.spaceXL),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      decoration: BoxDecoration(
        gradient: AppTheme.peacefulGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 60,
            color: AppTheme.sacredWhite,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          Text(
            'Your Personalized Spiritual Journey',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.sacredWhite,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            'Tell us about your spiritual needs and we\'ll create a custom ritual just for you',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.sacredWhite.withOpacity(0.9),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Full Name *',
        hintText: 'Enter your full name',
        prefixIcon: const Icon(Icons.person),
        suffixIcon: _nameController.text.length >= 2
            ? const Icon(Icons.check_circle, color: AppTheme.successGreen)
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        if (value.length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
      onChanged: (value) {
        _order.fullName = value;
        setState(() {});
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email *',
        hintText: 'your.email@example.com',
        prefixIcon: const Icon(Icons.email),
        suffixIcon: _isValidEmail(_emailController.text)
            ? const Icon(Icons.check_circle, color: AppTheme.successGreen)
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!_isValidEmail(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onChanged: (value) {
        _order.email = value;
        setState(() {});
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
        labelText: 'Phone Number *',
        hintText: '9876543210',
        prefixIcon: const Icon(Icons.phone),
        prefix: const Text('+91 '),
        suffixIcon: _phoneController.text.length == 10
            ? const Icon(Icons.check_circle, color: AppTheme.successGreen)
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (value.length != 10) {
          return 'Phone number must be exactly 10 digits';
        }
        return null;
      },
      onChanged: (value) {
        _order.phoneNumber = value;
        setState(() {});
      },
    );
  }

  Widget _buildRitualTypeField() {
    return DropdownButtonFormField<String>(
      value: _order.ritualType,
      decoration: const InputDecoration(
        labelText: 'Ritual Type *',
        prefixIcon: Icon(Icons.category),
      ),
      items: _ritualTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select a ritual type';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _order.ritualType = value;
        });
      },
    );
  }

  Widget _buildDeityPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deity Preference',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppTheme.spaceSM),
        Wrap(
          spacing: AppTheme.spaceSM,
          runSpacing: AppTheme.spaceSM,
          children: _deities.map((deity) {
            final isSelected = _order.deityPreferences.contains(deity);
            return FilterChip(
              label: Text(deity),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _order.deityPreferences = [..._order.deityPreferences, deity];
                  } else {
                    _order.deityPreferences = _order.deityPreferences
                        .where((d) => d != deity)
                        .toList();
                  }
                });
              },
              backgroundColor: AppTheme.sacredWhite,
              selectedColor: AppTheme.divineGold,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.sacredWhite : AppTheme.sacredGrey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time Selection *',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppTheme.spaceSM),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _order.selectedDate = date;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _order.selectedDate != null
                      ? '${_order.selectedDate!.day}/${_order.selectedDate!.month}/${_order.selectedDate!.year}'
                      : 'Select Date',
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spaceSM),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      _order.selectedTime = time.format(context);
                    });
                  }
                },
                icon: const Icon(Icons.access_time),
                label: Text(_order.selectedTime ?? 'Select Time'),
              ),
            ),
          ],
        ),
        if (_order.selectedDate == null || _order.selectedTime == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Please select both date and time',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorRed,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildSpecialInstructions() {
    return TextFormField(
      controller: _instructionsController,
      maxLines: 4,
      maxLength: 500,
      decoration: const InputDecoration(
        labelText: 'Special Instructions',
        hintText: 'Any specific requirements or preferences...',
        alignLabelWithHint: true,
      ),
      onChanged: (value) {
        _order.specialInstructions = value;
      },
    );
  }

  Widget _buildAashirwadPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aashirwad Box Preferences',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppTheme.spaceSM),
        ..._aashirwadOptions.map((option) {
          final isSelected = _order.aashirwadBoxPreferences.contains(option);
          return CheckboxListTile(
            title: Text(option),
            value: isSelected,
            activeColor: AppTheme.divineGold,
            onChanged: (selected) {
              setState(() {
                if (selected == true) {
                  _order.aashirwadBoxPreferences = [
                    ..._order.aashirwadBoxPreferences,
                    option
                  ];
                } else {
                  _order.aashirwadBoxPreferences = _order.aashirwadBoxPreferences
                      .where((o) => o != option)
                      .toList();
                }
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildAdditionalNotes() {
    return TextFormField(
      controller: _notesController,
      maxLines: 3,
      maxLength: 300,
      decoration: const InputDecoration(
        labelText: 'Additional Notes (Optional)',
        hintText: 'Any other information you\'d like to share...',
        alignLabelWithHint: true,
      ),
      onChanged: (value) {
        _order.additionalNotes = value;
      },
    );
  }

  Widget _buildPricingGuide() {
    return ExpansionTile(
      leading: const Icon(Icons.info_outline, color: AppTheme.divineGold),
      title: const Text('Pricing Guide'),
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estimated Price Range: ₹500 - ₹5000',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.divineGold,
                    ),
              ),
              const SizedBox(height: AppTheme.spaceSM),
              const Text('Factors affecting cost:'),
              const SizedBox(height: AppTheme.spaceXS),
              ...[
                'Type of ritual and complexity',
                'Number of deities involved',
                'Duration of the ceremony',
                'Special materials required',
                'Aashirwad box contents',
              ].map((factor) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6),
                        const SizedBox(width: 8),
                        Expanded(child: Text(factor)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProcessTimeline() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What Happens Next',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spaceMD),
            _buildTimelineStep('1', 'Consultation', 'Within 24 hours'),
            _buildTimelineStep('2', 'Preparation', '1-2 days'),
            _buildTimelineStep('3', 'Streaming', 'On scheduled date'),
            _buildTimelineStep('4', 'Delivery', '3-5 days after'),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(String number, String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceSM),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.divineGold,
            child: Text(
              number,
              style: const TextStyle(
                color: AppTheme.sacredWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spaceSM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.earthTones,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isValid = _order.isValid;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isValid && !_isSubmitting ? _submitForm : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceMD),
          backgroundColor: isValid ? AppTheme.divineGold : AppTheme.earthTones,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.sacredWhite),
                ),
              )
            : const Text('Submit Request'),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _order.isValid) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isSubmitting = false;
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    final confirmationNumber = Random().nextInt(900000) + 100000;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: AppTheme.successGreen, size: 32),
            SizedBox(width: 8),
            Text('Thank You!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your ritual request has been received successfully.'),
            const SizedBox(height: AppTheme.spaceMD),
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceSM),
              decoration: BoxDecoration(
                color: AppTheme.divineGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Confirmation Number:'),
                  Text(
                    '#$confirmationNumber',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.divineGold,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spaceMD),
            const Text('We\'ll contact you within 24 hours to discuss your custom ritual.'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _resetForm();
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showUnsavedChangesDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text(
              'You have unsaved changes. Are you sure you want to leave?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorRed,
                ),
                child: const Text('Leave'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _instructionsController.clear();
    _notesController.clear();
    _order.reset();
    setState(() {
      _hasUnsavedChanges = false;
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
