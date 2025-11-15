import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class PersonalRitualScreen extends StatefulWidget {
  const PersonalRitualScreen({super.key});

  @override
  State<PersonalRitualScreen> createState() => _PersonalRitualScreenState();
}

class _PersonalRitualScreenState extends State<PersonalRitualScreen> {
  String selectedType = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildRitualTypeSelector(),
            _buildQuickIntentButtons(),
            _buildFeaturedRituals(),
          ],
        ),
      ),
      floatingActionButton: _buildCustomRitualFAB(),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.sacredBlue, AppTheme.sacredBlue.withOpacity(0.8)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.temple_hindu, size: 150, color: Colors.white),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your Personal Spiritual Journey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create a ritual tailored to your needs',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRitualTypeSelector() {
    final types = ['All', 'Daily Deity', 'Special', 'Personal', 'Astrological', 'Life Events'];
    
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: types.length,
        itemBuilder: (context, index) {
          final type = types[index];
          final isSelected = selectedType == type;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => selectedType = type);
              },
              selectedColor: AppTheme.goldenAccent,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.sacredGrey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickIntentButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildIntentCard('🎯', 'For Specific Life Goal', 'Career, Marriage, Health...'),
          _buildIntentCard('🔮', 'Based on Kundli/Astrology', 'Resolve doshas & planetary issues'),
          _buildIntentCard('📅', 'For Special Occasion', 'Birthday, Anniversary, New Home'),
          _buildIntentCard('🙏', 'Daily Worship Subscription', 'Regular puja in your name'),
        ],
      ),
    );
  }

  Widget _buildIntentCard(String emoji, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 32)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showCustomRitualForm(),
      ),
    );
  }

  Widget _buildFeaturedRituals() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Featured Personal Rituals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
            children: [
              _buildRitualCard('Ganesh Puja', '₹501'),
              _buildRitualCard('Lakshmi Puja', '₹701'),
              _buildRitualCard('Shiva Abhishek', '₹901'),
              _buildRitualCard('Hanuman Puja', '₹401'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRitualCard(String name, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: AppTheme.sacredGradient,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Center(child: Icon(Icons.temple_hindu, size: 48, color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(color: AppTheme.sacredBlue, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showCustomRitualForm(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.goldenAccent,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Book', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomRitualFAB() {
    return FloatingActionButton.extended(
      onPressed: _showCustomRitualForm,
      backgroundColor: AppTheme.goldenAccent,
      icon: const Icon(Icons.edit),
      label: const Text('Create Custom'),
    );
  }

  void _showCustomRitualForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CustomRitualFormModal(),
    );
  }
}

class CustomRitualFormModal extends StatefulWidget {
  const CustomRitualFormModal({super.key});

  @override
  State<CustomRitualFormModal> createState() => _CustomRitualFormModalState();
}

class _CustomRitualFormModalState extends State<CustomRitualFormModal> {
  int currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildProgressIndicator(),
          Expanded(child: _buildStepContent()),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Custom Ritual', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(6, (index) {
          final isCompleted = index < currentStep;
          final isActive = index == currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isCompleted || isActive ? AppTheme.goldenAccent : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step ${currentStep + 1} of 6', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            if (currentStep == 0) _buildBasicInfo(),
            if (currentStep == 1) _buildRitualPreferences(),
            if (currentStep == 2) _buildTimingDetails(),
            if (currentStep == 3) _buildAashirwadBox(),
            if (currentStep == 4) _buildPackageSelection(),
            if (currentStep == 5) _buildReviewConfirmation(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Basic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextFormField(decoration: const InputDecoration(labelText: 'Full Name *', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextFormField(decoration: const InputDecoration(labelText: 'Email *', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextFormField(decoration: const InputDecoration(labelText: 'Phone *', border: OutlineInputBorder())),
      ],
    );
  }

  Widget _buildRitualPreferences() {
    return const Column(
      children: [
        Text('Ritual Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text('Select your primary intention and deity preferences'),
      ],
    );
  }

  Widget _buildTimingDetails() {
    return const Column(
      children: [
        Text('Timing & Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text('Choose your preferred date and time'),
      ],
    );
  }

  Widget _buildAashirwadBox() {
    return const Column(
      children: [
        Text('Aashirwad Box', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text('Customize your blessing box'),
      ],
    );
  }

  Widget _buildPackageSelection() {
    return const Column(
      children: [
        Text('Package Selection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text('Choose your package type'),
      ],
    );
  }

  Widget _buildReviewConfirmation() {
    return const Column(
      children: [
        Text('Review & Confirm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text('Review your ritual details'),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentStep > 0)
            TextButton(
              onPressed: () => setState(() => currentStep--),
              child: const Text('Back'),
            )
          else
            const SizedBox(),
          Text('Step ${currentStep + 1} of 6', style: TextStyle(color: Colors.grey.shade600)),
          ElevatedButton(
            onPressed: () {
              if (currentStep < 5) {
                setState(() => currentStep++);
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ritual booking submitted!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldenAccent),
            child: Text(currentStep < 5 ? 'Next' : 'Submit'),
          ),
        ],
      ),
    );
  }
}
