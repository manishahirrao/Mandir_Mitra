import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/tracking_provider.dart';
import '../models/tracking_info.dart';
import '../utils/app_theme.dart';

class ReportDeliveryIssueScreen extends StatefulWidget {
  final String orderId;

  const ReportDeliveryIssueScreen({super.key, required this.orderId});

  @override
  State<ReportDeliveryIssueScreen> createState() =>
      _ReportDeliveryIssueScreenState();
}

class _ReportDeliveryIssueScreenState extends State<ReportDeliveryIssueScreen> {
  IssueType _selectedIssue = IssueType.notReceived;
  final _descriptionController = TextEditingController();
  final List<File> _photos = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issue'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What\'s the issue?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildIssueTypeSelector(),
            const SizedBox(height: 24),
            const Text(
              'Describe the issue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText: 'Please provide details about the issue...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Add Photos (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildPhotoSection(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitIssue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sacredBlue,
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Submit Issue',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueTypeSelector() {
    return Column(
      children: [
        _buildIssueOption(
          IssueType.notReceived,
          'Box not received',
          Icons.cancel,
        ),
        _buildIssueOption(
          IssueType.damaged,
          'Damaged items',
          Icons.broken_image,
        ),
        _buildIssueOption(
          IssueType.missingItems,
          'Missing items',
          Icons.inventory_2,
        ),
        _buildIssueOption(
          IssueType.lateDelivery,
          'Late delivery',
          Icons.schedule,
        ),
        _buildIssueOption(
          IssueType.other,
          'Other',
          Icons.more_horiz,
        ),
      ],
    );
  }

  Widget _buildIssueOption(IssueType type, String label, IconData icon) {
    return RadioListTile<IssueType>(
      value: type,
      groupValue: _selectedIssue,
      onChanged: (value) {
        setState(() {
          _selectedIssue = value!;
        });
      },
      title: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildPhotoSection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._photos.map((photo) => _buildPhotoThumbnail(photo)),
        if (_photos.length < 5) _buildAddPhotoButton(),
      ],
    );
  }

  Widget _buildPhotoThumbnail(File photo) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(photo),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _photos.remove(photo);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, color: Colors.grey),
            SizedBox(height: 4),
            Text(
              'Add',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _photos.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _submitIssue() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe the issue')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final issue = DeliveryIssue(
      id: 'ISSUE${DateTime.now().millisecondsSinceEpoch}',
      orderId: widget.orderId,
      issueType: _selectedIssue,
      description: _descriptionController.text.trim(),
      photos: _photos.map((f) => f.path).toList(),
      status: 'Submitted',
      ticketId: 'TKT${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    final ticketId = await Provider.of<TrackingProvider>(context, listen: false)
        .reportIssue(issue);

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Issue Reported'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 64,
                color: AppTheme.successGreen,
              ),
              const SizedBox(height: 16),
              Text(
                'Ticket ID: $ticketId',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Our team will contact you within 24 hours',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sacredBlue,
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }
}
