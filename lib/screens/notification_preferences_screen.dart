import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_provider.dart';
import '../utils/app_theme.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  late Map<String, bool> _preferences;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    _preferences = {
      'booking_confirmations': provider.getPreference('booking_confirmations'),
      'ritual_reminders': provider.getPreference('ritual_reminders'),
      'rescheduling_updates': provider.getPreference('rescheduling_updates'),
      'cancellation_confirmations': provider.getPreference('cancellation_confirmations'),
      'payment_confirmations': provider.getPreference('payment_confirmations'),
      'invoice_generation': provider.getPreference('invoice_generation'),
      'refund_updates': provider.getPreference('refund_updates'),
      'box_dispatch': provider.getPreference('box_dispatch'),
      'out_for_delivery': provider.getPreference('out_for_delivery'),
      'delivery_confirmation': provider.getPreference('delivery_confirmation'),
      'stream_starting': provider.getPreference('stream_starting'),
      'stream_recording': provider.getPreference('stream_recording'),
      'special_offers': provider.getPreference('special_offers'),
      'new_rituals': provider.getPreference('new_rituals'),
      'festival_greetings': provider.getPreference('festival_greetings'),
      'push_notifications': provider.getPreference('push_notifications'),
      'email': provider.getPreference('email'),
      'sms': provider.getPreference('sms'),
      'whatsapp': provider.getPreference('whatsapp'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSection(
                    'Booking & Order Updates',
                    [
                      _buildToggle('Booking confirmations', 'booking_confirmations'),
                      _buildToggle('Ritual reminders', 'ritual_reminders'),
                      _buildToggle('Rescheduling updates', 'rescheduling_updates'),
                      _buildToggle('Cancellation confirmations', 'cancellation_confirmations'),
                    ],
                  ),
                  _buildSection(
                    'Payment & Billing',
                    [
                      _buildToggle('Payment confirmations', 'payment_confirmations'),
                      _buildToggle('Invoice generation', 'invoice_generation'),
                      _buildToggle('Refund updates', 'refund_updates'),
                    ],
                  ),
                  _buildSection(
                    'Delivery Updates',
                    [
                      _buildToggle('Aashirwad Box dispatch', 'box_dispatch'),
                      _buildToggle('Out for delivery', 'out_for_delivery'),
                      _buildToggle('Delivery confirmation', 'delivery_confirmation'),
                    ],
                  ),
                  _buildSection(
                    'Live Stream',
                    [
                      _buildToggle('Stream starting soon', 'stream_starting'),
                      _buildToggle('Stream recording available', 'stream_recording'),
                    ],
                  ),
                  _buildSection(
                    'Promotional',
                    [
                      _buildToggle('Special offers & discounts', 'special_offers'),
                      _buildToggle('New ritual launches', 'new_rituals'),
                      _buildToggle('Festival greetings', 'festival_greetings'),
                    ],
                  ),
                  _buildSection(
                    'Communication Channels',
                    [
                      _buildToggle('Push notifications', 'push_notifications'),
                      _buildToggle('Email', 'email'),
                      _buildToggle('SMS', 'sms'),
                      _buildToggle('WhatsApp', 'whatsapp'),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildToggle(String label, String key) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(fontSize: 15)),
      value: _preferences[key] ?? true,
      onChanged: (value) {
        setState(() {
          _preferences[key] = value;
        });
      },
      activeColor: AppTheme.sacredBlue,
    );
  }

  Widget _buildSaveButton() {
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
        onPressed: _savePreferences,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.divineGold,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Save Preferences',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _savePreferences() async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    await provider.saveAllPreferences(_preferences);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preferences saved successfully'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      Navigator.pop(context);
    }
  }
}
