import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/review.dart';
import '../models/ritual.dart';
import '../models/ordered_ritual.dart';
import '../services/review_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/common/star_rating.dart';

class WriteReviewScreen extends StatefulWidget {
  final Ritual ritual;
  final OrderedRitual? order;
  final Review? existingReview;

  const WriteReviewScreen({
    super.key,
    required this.ritual,
    this.order,
    this.existingReview,
  });

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  
  double _rating = 0;
  bool _recommended = true;
  final List<File> _selectedPhotos = [];
  bool _agreedToTerms = false;
  bool _isSubmitting = false;

  // Aspect ratings
  double _ritualAuthenticity = 0;
  double _priestInteraction = 0;
  double _liveStreamQuality = 0;
  double _aashirwadBoxQuality = 0;

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _rating = widget.existingReview!.rating;
      _reviewController.text = widget.existingReview!.comment;
      _recommended = widget.existingReview!.recommended;
      if (widget.existingReview!.aspects != null) {
        _ritualAuthenticity = widget.existingReview!.aspects!.ritualAuthenticity;
        _priestInteraction = widget.existingReview!.aspects!.priestInteraction;
        _liveStreamQuality = widget.existingReview!.aspects!.liveStreamQuality;
        _aashirwadBoxQuality = widget.existingReview!.aspects!.aashirwadBoxQuality;
      }
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingReview != null ? 'Edit Review' : 'Write a Review'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRitualInfo(),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingSection(),
                    const SizedBox(height: 24),
                    _buildReviewTextField(),
                    const SizedBox(height: 24),
                    _buildPhotoSection(),
                    const SizedBox(height: 24),
                    _buildRecommendationSection(),
                    const SizedBox(height: 24),
                    _buildAspectRatings(),
                    const SizedBox(height: 24),
                    _buildTermsCheckbox(),
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRitualInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.sacredBlue.withOpacity(0.05),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.ritual.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.ritual.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.ritual.templeName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                if (widget.order != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${widget.order!.packageType} Package',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.sacredBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rate Your Experience *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: InteractiveStarRating(
            initialRating: _rating,
            size: 48,
            onRatingChanged: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            _getRatingLabel(_rating),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _getRatingColor(_rating),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tell us more *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _reviewController,
          maxLines: 6,
          maxLength: 500,
          decoration: const InputDecoration(
            hintText: 'Share details of your experience...',
            border: OutlineInputBorder(),
            counterText: '',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please share your experience';
            }
            if (value.trim().length < 20) {
              return 'Please write at least 20 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 4),
        Text(
          '${_reviewController.text.length}/500 characters',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Photos (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add up to 5 photos',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._selectedPhotos.map((photo) => _buildPhotoThumbnail(photo)),
            if (_selectedPhotos.length < 5) _buildAddPhotoButton(),
          ],
        ),
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
                _selectedPhotos.remove(photo);
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
          border: Border.all(color: Colors.grey, width: 2, style: BorderStyle.solid),
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

  Widget _buildRecommendationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Would you recommend this ritual? *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Yes'),
                value: true,
                groupValue: _recommended,
                onChanged: (value) {
                  setState(() {
                    _recommended = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('No'),
                value: false,
                groupValue: _recommended,
                onChanged: (value) {
                  setState(() {
                    _recommended = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAspectRatings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rate Specific Aspects (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildAspectRating(
          'Ritual Authenticity',
          _ritualAuthenticity,
          (rating) => setState(() => _ritualAuthenticity = rating),
        ),
        const SizedBox(height: 12),
        _buildAspectRating(
          'Priest Interaction',
          _priestInteraction,
          (rating) => setState(() => _priestInteraction = rating),
        ),
        const SizedBox(height: 12),
        _buildAspectRating(
          'Live Stream Quality',
          _liveStreamQuality,
          (rating) => setState(() => _liveStreamQuality = rating),
        ),
        const SizedBox(height: 12),
        _buildAspectRating(
          'Aashirwad Box Quality',
          _aashirwadBoxQuality,
          (rating) => setState(() => _aashirwadBoxQuality = rating),
        ),
      ],
    );
  }

  Widget _buildAspectRating(
    String label,
    double rating,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          flex: 3,
          child: InteractiveStarRating(
            initialRating: rating,
            size: 24,
            onRatingChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return CheckboxListTile(
      value: _agreedToTerms,
      onChanged: (value) {
        setState(() {
          _agreedToTerms = value!;
        });
      },
      title: const Text(
        'I certify this review is based on my own experience',
        style: TextStyle(fontSize: 13),
      ),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildSubmitButton() {
    final isValid = _rating > 0 &&
        _reviewController.text.trim().length >= 20 &&
        _agreedToTerms;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isValid && !_isSubmitting ? _submitReview : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.divineGold,
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                widget.existingReview != null ? 'Update Review' : 'Submit Review',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  String _getRatingLabel(double rating) {
    if (rating == 0) return 'Tap to rate';
    if (rating == 1) return 'Poor';
    if (rating == 2) return 'Fair';
    if (rating == 3) return 'Good';
    if (rating == 4) return 'Very Good';
    return 'Excellent';
  }

  Color _getRatingColor(double rating) {
    if (rating == 0) return Colors.grey;
    if (rating <= 2) return AppTheme.errorRed;
    if (rating <= 3) return AppTheme.warningAmber;
    return AppTheme.successGreen;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _selectedPhotos.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final review = Review(
      id: widget.existingReview?.id ?? 'REV${DateTime.now().millisecondsSinceEpoch}',
      userId: 'USER001',
      ritualId: widget.ritual.id,
      orderId: widget.order?.id,
      customerName: 'Current User',
      customerPhoto: 'https://i.pravatar.cc/150?img=33',
      rating: _rating,
      comment: _reviewController.text.trim(),
      photos: _selectedPhotos.map((f) => f.path).toList(),
      packageType: widget.order?.packageType,
      isVerified: widget.order != null,
      date: widget.existingReview?.date ?? DateTime.now(),
      lastEditedDate: widget.existingReview != null ? DateTime.now() : null,
      recommended: _recommended,
      aspects: (_ritualAuthenticity > 0 ||
              _priestInteraction > 0 ||
              _liveStreamQuality > 0 ||
              _aashirwadBoxQuality > 0)
          ? ReviewAspects(
              ritualAuthenticity: _ritualAuthenticity,
              priestInteraction: _priestInteraction,
              liveStreamQuality: _liveStreamQuality,
              aashirwadBoxQuality: _aashirwadBoxQuality,
            )
          : null,
    );

    final provider = Provider.of<ReviewProvider>(context, listen: false);
    final success = widget.existingReview != null
        ? await provider.updateReview(widget.existingReview!.id, review)
        : await provider.submitReview(review);

    setState(() {
      _isSubmitting = false;
    });

    if (success && mounted) {
      _showThankYouDialog();
    }
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Thank You!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppTheme.successGreen,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              widget.existingReview != null
                  ? 'Your review has been updated successfully!'
                  : 'Thank you for sharing your experience!',
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
