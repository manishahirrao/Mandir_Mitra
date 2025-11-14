import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Mandir Mitra'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            _buildOurStory(),
            _buildOurValues(),
            _buildOurTeam(),
            _buildTemplePartnerships(),
            _buildOurCommitment(),
            _buildContactCTA(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.sacredBlue, AppTheme.sacredBlue.withOpacity(0.7)],
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: Icon(Icons.temple_hindu, size: 60, color: AppTheme.sacredBlue),
          ),
          const SizedBox(height: 16),
          const Text(
            'Connecting Devotees with Divine Blessings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Bringing authentic temple rituals to your doorstep',
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOurStory() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Story',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Mandir Mitra was born from a simple yet powerful vision: to make authentic spiritual rituals accessible to everyone, regardless of their location or circumstances.',
            style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          const Text(
            'Founded in 2020, we recognized that many devotees face challenges in visiting temples or performing traditional rituals due to distance, time constraints, or physical limitations. We set out to bridge this gap by leveraging technology while maintaining the sanctity and authenticity of age-old traditions.',
            style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          const Text(
            'Today, we partner with over 50 renowned temples across India, connecting thousands of devotees with divine blessings through live-streamed rituals and personalized Aashirwad Boxes.',
            style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildOurValues() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.sacredBlue.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Values',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildValueCard(Icons.verified, 'Authenticity',
                  'Every ritual follows traditional Vedic procedures'),
              _buildValueCard(Icons.handshake, 'Trust',
                  'Transparent processes and genuine partnerships'),
              _buildValueCard(Icons.auto_awesome, 'Tradition',
                  'Preserving ancient wisdom for modern times'),
              _buildValueCard(Icons.lightbulb, 'Innovation',
                  'Using technology to enhance spiritual experiences'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(IconData icon, String title, String description) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppTheme.sacredBlue),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.templeBrown,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOurTeam() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Team',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
            children: [
              _buildTeamMember('Amit Sharma', 'Founder & CEO',
                  'https://i.pravatar.cc/150?img=12'),
              _buildTeamMember('Priya Patel', 'Head of Operations',
                  'https://i.pravatar.cc/150?img=45'),
              _buildTeamMember('Rajesh Kumar', 'Temple Relations',
                  'https://i.pravatar.cc/150?img=33'),
              _buildTeamMember('Meera Iyer', 'Spiritual Advisor',
                  'https://i.pravatar.cc/150?img=47'),
              _buildTeamMember('Vikram Singh', 'Technology Lead',
                  'https://i.pravatar.cc/150?img=51'),
              _buildTeamMember('Anita Desai', 'Customer Success',
                  'https://i.pravatar.cc/150?img=48'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          role,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTemplePartnerships() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.sacredBlue.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Temple Partnerships',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'We partner with renowned temples across India to bring you authentic spiritual experiences:',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildTempleChip('Jagannath Temple, Puri'),
              _buildTempleChip('Kashi Vishwanath, Varanasi'),
              _buildTempleChip('Meenakshi Temple, Madurai'),
              _buildTempleChip('Dakshineswar Temple, Kolkata'),
              _buildTempleChip('Mahakaleshwar, Ujjain'),
              _buildTempleChip('Somnath Temple, Gujarat'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTempleChip(String name) {
    return Chip(
      label: Text(name),
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppTheme.sacredBlue),
      labelStyle: const TextStyle(color: AppTheme.sacredBlue),
    );
  }

  Widget _buildOurCommitment() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Commitment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 16),
          _buildCommitmentItem(Icons.check_circle, 'Quality',
              'Only certified priests and authentic rituals'),
          _buildCommitmentItem(Icons.check_circle, 'Authenticity',
              'Traditional procedures followed meticulously'),
          _buildCommitmentItem(Icons.check_circle, 'Service',
              '24/7 customer support for all your needs'),
          _buildCommitmentItem(Icons.check_circle, 'Privacy',
              'Your personal information is always protected'),
        ],
      ),
    );
  }

  Widget _buildCommitmentItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.successGreen, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.templeBrown,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCTA(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.sacredBlue, AppTheme.sacredBlue.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Have Questions?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Our team is here to help you',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.sacredBlue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Contact Us', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
