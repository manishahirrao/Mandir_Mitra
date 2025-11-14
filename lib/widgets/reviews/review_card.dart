import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/review.dart';
import '../../services/review_provider.dart';
import '../../utils/app_theme.dart';
import '../common/star_rating.dart';

class ReviewCard extends StatefulWidget {
  final Review review;
  final bool showMostHelpfulBadge;

  const ReviewCard({
    super.key,
    required this.review,
    this.showMostHelpfulBadge = false,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final needsExpansion = widget.review.comment.length > 200;
    final displayText = !_isExpanded && needsExpansion
        ? '${widget.review.comment.substring(0, 200)}...'
        : widget.review.comment;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showMostHelpfulBadge) _buildMostHelpfulBadge(),
            _buildHeader(),
            const SizedBox(height: 12),
            _buildRating(),
            const SizedBox(height: 8),
            _buildReviewText(displayText, needsExpansion),
            if (widget.review.photos.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildPhotos(),
            ],
            if (widget.review.packageType != null) ...[
              const SizedBox(height: 8),
              _buildPackageType(),
            ],
            const SizedBox(height: 12),
            _buildFooter(),
            if (widget.review.adminResponse != null) ...[
              const SizedBox(height: 12),
              _buildAdminResponse(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMostHelpfulBadge() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.divineGold.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: AppTheme.divineGold),
          SizedBox(width: 4),
          Text(
            'Most Helpful',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.divineGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(widget.review.customerPhoto),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.review.customerName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.review.isVerified) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified,
                      size: 16,
                      color: AppTheme.successGreen,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                _formatDate(widget.review.date),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              if (widget.review.lastEditedDate != null)
                Text(
                  'Edited ${_formatDate(widget.review.lastEditedDate!)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 20),
          onSelected: (value) {
            if (value == 'report') {
              _showReportDialog();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  Icon(Icons.flag_outlined, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Report'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        StarRating(
          rating: widget.review.rating,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          widget.review.rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewText(String text, bool needsExpansion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        if (needsExpansion)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _isExpanded ? 'Read less' : 'Read more',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.sacredBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPhotos() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.review.photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showPhotoViewer(index),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(widget.review.photos[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPackageType() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.sacredBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        widget.review.packageType!,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.sacredBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Consumer<ReviewProvider>(
          builder: (context, provider, child) {
            final isHelpful = provider.isReviewHelpful(widget.review.id);
            return OutlinedButton.icon(
              onPressed: () {
                provider.markReviewHelpful(widget.review.id);
              },
              icon: Icon(
                isHelpful ? Icons.thumb_up : Icons.thumb_up_outlined,
                size: 16,
              ),
              label: Text(
                'Helpful${widget.review.helpfulCount > 0 ? ' (${widget.review.helpfulCount})' : ''}',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: isHelpful ? AppTheme.sacredBlue : Colors.grey,
                side: BorderSide(
                  color: isHelpful ? AppTheme.sacredBlue : Colors.grey,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
        if (widget.review.helpfulCount > 0) ...[
          const SizedBox(width: 8),
          Text(
            '${widget.review.helpfulCount} ${widget.review.helpfulCount == 1 ? 'person' : 'people'} found this helpful',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ],
    );
  }

  Widget _buildAdminResponse() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.sacredBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.sacredBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.temple_hindu,
                size: 16,
                color: AppTheme.sacredBlue,
              ),
              const SizedBox(width: 6),
              const Text(
                'Response from Mandir Mitra',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.sacredBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.review.adminResponse!.responseText,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 6),
          Text(
            _formatDate(widget.review.adminResponse!.responseDate),
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  void _showPhotoViewer(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewerScreen(
          photos: widget.review.photos,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => ReportReviewDialog(reviewId: widget.review.id),
    );
  }
}

class PhotoViewerScreen extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;

  const PhotoViewerScreen({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} / ${widget.photos.length}'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.photos.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.network(
                widget.photos[index],
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReportReviewDialog extends StatefulWidget {
  final String reviewId;

  const ReportReviewDialog({super.key, required this.reviewId});

  @override
  State<ReportReviewDialog> createState() => _ReportReviewDialogState();
}

class _ReportReviewDialogState extends State<ReportReviewDialog> {
  String _selectedReason = 'Spam';
  final _commentsController = TextEditingController();

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Report Review'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Why are you reporting this review?'),
            const SizedBox(height: 12),
            ...['Spam', 'Offensive Content', 'Fake Review', 'Other'].map(
              (reason) => RadioListTile<String>(
                title: Text(reason),
                value: reason,
                groupValue: _selectedReason,
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Additional comments (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await Provider.of<ReviewProvider>(context, listen: false)
                .reportReview(widget.reviewId, _selectedReason);
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you for reporting. We\'ll review this.'),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.errorRed,
          ),
          child: const Text('Submit Report'),
        ),
      ],
    );
  }
}
