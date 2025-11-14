import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/ritual.dart';
import '../models/booking.dart';
import '../models/user.dart';
import '../services/booking_provider.dart';
import '../services/user_provider.dart';
import '../utils/app_theme.dart';

class BookingScreen extends StatefulWidget {
  final Ritual ritual;
  final String selectedPackage;

  const BookingScreen({
    super.key,
    required this.ritual,
    required this.selectedPackage,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  int _participants = 1;
  String _selectedPriest = 'Any Available';
  final _specialRequestsController = TextEditingController();
  bool _includeAashirwadBox = true;
  final Set<String> _selectedAddOns = {};
  SavedAddress? _selectedAddress;
  bool _acceptTerms = false;

  final List<String> _timeSlots = [
    '6:00 AM - 12:00 PM',
    '12:00 PM - 6:00 PM',
    '6:00 PM - 9:00 PM',
  ];

  final List<String> _priests = [
    'Any Available',
    'Pandit Rajesh Sharma',
    'Pandit Suresh Mishra',
    'Pandit Anil Chatterjee',
  ];

  final Map<String, double> _addOnItems = {
    'Extra Prasad': 200,
    'Rudraksha Mala': 500,
    'Sacred Thread Set': 150,
    'Kumkum & Vibhuti': 100,
  };

  @override
  void dispose() {
    _specialRequestsController.dispose();
    super.dispose();
  }

  double get _basePrice {
    final packagePrices = {
      'Shared': widget.ritual.price * 0.2,
      'Family': widget.ritual.price,
      'Personal': widget.ritual.price * 2.2,
    };
    return (packagePrices[widget.selectedPackage] ?? 0) * _participants;
  }

  double get _aashirwadBoxPrice => _includeAashirwadBox ? 500 : 0;

  double get _addOnsPrice {
    return _selectedAddOns.fold(0.0, (sum, item) => sum + (_addOnItems[item] ?? 0));
  }

  double get _taxAmount => (_basePrice + _aashirwadBoxPrice + _addOnsPrice) * 0.18;

  double get _totalAmount => _basePrice + _aashirwadBoxPrice + _addOnsPrice + _taxAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Ritual'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRitualSummary(),
                    const SizedBox(height: 24),
                    _buildDateTimeSelection(),
                    const SizedBox(height: 16),
                    _buildParticipantsCounter(),
                    const SizedBox(height: 16),
                    _buildPriestSelection(),
                    const SizedBox(height: 16),
                    _buildSpecialRequests(),
                    const SizedBox(height: 16),
                    _buildAashirwadBoxSection(),
                    if (_includeAashirwadBox) ...[
                      const SizedBox(height: 16),
                      _buildAddressSelection(),
                    ],
                    const SizedBox(height: 16),
                    _buildPriceBreakdown(),
                    const SizedBox(height: 16),
                    _buildTermsCheckbox(),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildRitualSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.ritual.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ritual.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.templeBrown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.temple_hindu, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.ritual.templeName,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.sacredBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${widget.selectedPackage} Package',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.sacredBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date & Time',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now().add(const Duration(days: 1)),
              lastDate: DateTime.now().add(const Duration(days: 90)),
            );
            if (date != null) {
              setState(() {
                _selectedDate = date;
              });
            }
          },
          icon: const Icon(Icons.calendar_today),
          label: Text(
            _selectedDate == null
                ? 'Select Date'
                : DateFormat('dd MMM yyyy').format(_selectedDate!),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(
              color: _selectedDate == null ? Colors.grey : AppTheme.sacredBlue,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Time Slot', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _timeSlots.map((slot) {
            final isSelected = _selectedTimeSlot == slot;
            return FilterChip(
              label: Text(slot),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedTimeSlot = selected ? slot : null;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppTheme.sacredBlue.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.sacredBlue : Colors.black87,
              ),
              side: BorderSide(
                color: isSelected ? AppTheme.sacredBlue : Colors.grey[300]!,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildParticipantsCounter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of Participants',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              onPressed: _participants > 1
                  ? () => setState(() => _participants--)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppTheme.sacredBlue,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.sacredBlue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$_participants',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.templeBrown,
                ),
              ),
            ),
            IconButton(
              onPressed: () => setState(() => _participants++),
              icon: const Icon(Icons.add_circle_outline),
              color: AppTheme.sacredBlue,
            ),
            const Spacer(),
            Text(
              '₹${_basePrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.templeBrown,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriestSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priest Preference',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedPriest,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: _priests.map((priest) {
            return DropdownMenuItem(value: priest, child: Text(priest));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPriest = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSpecialRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Special Requests (Optional)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _specialRequestsController,
          maxLines: 3,
          maxLength: 200,
          decoration: InputDecoration(
            hintText: 'Any specific requirements or preferences...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildAashirwadBoxSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Include Aashirwad Box',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Switch(
              value: _includeAashirwadBox,
              onChanged: (value) {
                setState(() {
                  _includeAashirwadBox = value;
                  if (!value) {
                    _selectedAddOns.clear();
                    _selectedAddress = null;
                  }
                });
              },
              activeColor: AppTheme.sacredBlue,
            ),
          ],
        ),
        if (_includeAashirwadBox) ...[
          const SizedBox(height: 8),
          Text(
            '+₹$_aashirwadBoxPrice',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.sacredBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const Text('Add-on Items', style: TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          ..._addOnItems.entries.map((entry) {
            return CheckboxListTile(
              title: Text(entry.key),
              subtitle: Text('+₹${entry.value.toStringAsFixed(0)}'),
              value: _selectedAddOns.contains(entry.key),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedAddOns.add(entry.key);
                  } else {
                    _selectedAddOns.remove(entry.key);
                  }
                });
              },
              activeColor: AppTheme.sacredBlue,
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ],
    );
  }

  Widget _buildAddressSelection() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final addresses = userProvider.addresses;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<SavedAddress>(
              value: _selectedAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              hint: const Text('Select delivery address'),
              items: [
                ...addresses.map((address) {
                  return DropdownMenuItem(
                    value: address,
                    child: Text('${address.label} - ${address.city}'),
                  );
                }),
                const DropdownMenuItem(
                  value: null,
                  child: Text('+ Add New Address'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedAddress = value;
                });
              },
              validator: (value) {
                if (_includeAashirwadBox && value == null) {
                  return 'Please select a delivery address';
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceBreakdown() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Breakdown',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPriceRow('Base Price', _basePrice),
            if (_includeAashirwadBox)
              _buildPriceRow('Aashirwad Box', _aashirwadBoxPrice),
            if (_addOnsPrice > 0) _buildPriceRow('Add-ons', _addOnsPrice),
            _buildPriceRow('GST (18%)', _taxAmount),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.templeBrown,
                  ),
                ),
                Text(
                  '₹${_totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.divineGold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          activeColor: AppTheme.sacredBlue,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'I agree to the cancellation policy',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _acceptTerms ? _proceedToPayment : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.divineGold,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: const Text(
          'Proceed to Payment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _proceedToPayment() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTimeSlot == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select date and time'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
        return;
      }

      final booking = Booking(
        id: 'BK${DateTime.now().millisecondsSinceEpoch}',
        ritualId: widget.ritual.id,
        ritualName: widget.ritual.name,
        ritualImage: widget.ritual.imageUrl,
        userId: 'USER001',
        templeName: widget.ritual.templeName,
        templeLocation: 'India',
        packageType: widget.selectedPackage,
        participants: _participants,
        scheduledDateTime: DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTimeSlot == _timeSlots[0] ? 6 : (_selectedTimeSlot == _timeSlots[1] ? 12 : 18),
        ),
        priestName: _selectedPriest != 'Any Available' ? _selectedPriest : null,
        specialRequests: _specialRequestsController.text,
        includeAashirwadBox: _includeAashirwadBox,
        addOnItems: _selectedAddOns.toList(),
        deliveryAddressId: _selectedAddress?.id,
        basePrice: _basePrice,
        aashirwadBoxPrice: _aashirwadBoxPrice,
        addOnsPrice: _addOnsPrice,
        taxAmount: _taxAmount,
        totalAmount: _totalAmount,
        createdAt: DateTime.now(),
      );

      Provider.of<BookingProvider>(context, listen: false).setCurrentBooking(booking);

      // Navigate to payment screen (to be implemented)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proceeding to payment... (Payment screen coming soon)'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }
}
