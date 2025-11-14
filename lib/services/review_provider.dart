import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/review.dart';

enum ReviewSort { mostRecent, highestRated, lowestRated, mostHelpful }

enum ReviewFilter { all, fiveStar, fourStar, threeStar, withPhotos, verified }

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  final Set<String> _helpfulReviews = {};
  bool _isLoading = false;

  ReviewProvider() {
    _loadMockReviews();
    _loadHelpfulReviews();
  }

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;

  void _loadMockReviews() {
    _reviews = _generateMockReviews();
    notifyListeners();
  }

  Future<void> _loadHelpfulReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final helpfulJson = prefs.getString('helpful_reviews');
      if (helpfulJson != null) {
        final List<dynamic> decoded = json.decode(helpfulJson);
        _helpfulReviews.addAll(decoded.cast<String>());
      }
    } catch (e) {
      debugPrint('Error loading helpful reviews: $e');
    }
  }

  Future<void> _saveHelpfulReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'helpful_reviews',
        json.encode(_helpfulReviews.toList()),
      );
    } catch (e) {
      debugPrint('Error saving helpful reviews: $e');
    }
  }

  List<Review> getReviewsByRitual(
    String ritualId, {
    ReviewFilter filter = ReviewFilter.all,
    ReviewSort sort = ReviewSort.mostRecent,
  }) {
    var filtered = _reviews.where((r) => r.ritualId == ritualId).toList();

    // Apply filters
    switch (filter) {
      case ReviewFilter.fiveStar:
        filtered = filtered.where((r) => r.rating == 5.0).toList();
        break;
      case ReviewFilter.fourStar:
        filtered = filtered.where((r) => r.rating >= 4.0 && r.rating < 5.0).toList();
        break;
      case ReviewFilter.threeStar:
        filtered = filtered.where((r) => r.rating >= 3.0 && r.rating < 4.0).toList();
        break;
      case ReviewFilter.withPhotos:
        filtered = filtered.where((r) => r.photos.isNotEmpty).toList();
        break;
      case ReviewFilter.verified:
        filtered = filtered.where((r) => r.isVerified).toList();
        break;
      case ReviewFilter.all:
        break;
    }

    // Apply sorting
    switch (sort) {
      case ReviewSort.mostRecent:
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case ReviewSort.highestRated:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ReviewSort.lowestRated:
        filtered.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case ReviewSort.mostHelpful:
        filtered.sort((a, b) => b.helpfulCount.compareTo(a.helpfulCount));
        break;
    }

    return filtered;
  }

  List<Review> getReviewsByUser(String userId) {
    return _reviews.where((r) => r.userId == userId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Review> getMostHelpfulReviews(String ritualId, {int limit = 3}) {
    final ritualReviews = _reviews
        .where((r) => r.ritualId == ritualId)
        .toList()
      ..sort((a, b) => b.helpfulCount.compareTo(a.helpfulCount));
    return ritualReviews.take(limit).toList();
  }

  double calculateAverageRating(String ritualId) {
    final ritualReviews = _reviews.where((r) => r.ritualId == ritualId).toList();
    if (ritualReviews.isEmpty) return 0.0;
    
    final sum = ritualReviews.fold<double>(0, (sum, r) => sum + r.rating);
    return sum / ritualReviews.length;
  }

  int getReviewCount(String ritualId) {
    return _reviews.where((r) => r.ritualId == ritualId).length;
  }

  RatingDistribution getRatingDistribution(String ritualId) {
    final ritualReviews = _reviews.where((r) => r.ritualId == ritualId).toList();
    
    return RatingDistribution(
      fiveStars: ritualReviews.where((r) => r.rating == 5.0).length,
      fourStars: ritualReviews.where((r) => r.rating >= 4.0 && r.rating < 5.0).length,
      threeStars: ritualReviews.where((r) => r.rating >= 3.0 && r.rating < 4.0).length,
      twoStars: ritualReviews.where((r) => r.rating >= 2.0 && r.rating < 3.0).length,
      oneStar: ritualReviews.where((r) => r.rating >= 1.0 && r.rating < 2.0).length,
    );
  }

  Future<bool> submitReview(Review review) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _reviews.add(review);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> updateReview(String reviewId, Review updatedReview) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      _reviews[index] = updatedReview;
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> deleteReview(String reviewId) async {
    _reviews.removeWhere((r) => r.id == reviewId);
    notifyListeners();
    return true;
  }

  Future<void> markReviewHelpful(String reviewId) async {
    if (_helpfulReviews.contains(reviewId)) {
      _helpfulReviews.remove(reviewId);
      final index = _reviews.indexWhere((r) => r.id == reviewId);
      if (index != -1) {
        final review = _reviews[index];
        _reviews[index] = Review(
          id: review.id,
          userId: review.userId,
          ritualId: review.ritualId,
          orderId: review.orderId,
          customerName: review.customerName,
          customerPhoto: review.customerPhoto,
          rating: review.rating,
          comment: review.comment,
          photos: review.photos,
          packageType: review.packageType,
          isVerified: review.isVerified,
          helpfulCount: review.helpfulCount - 1,
          reportCount: review.reportCount,
          date: review.date,
          lastEditedDate: review.lastEditedDate,
          recommended: review.recommended,
          aspects: review.aspects,
          adminResponse: review.adminResponse,
        );
      }
    } else {
      _helpfulReviews.add(reviewId);
      final index = _reviews.indexWhere((r) => r.id == reviewId);
      if (index != -1) {
        final review = _reviews[index];
        _reviews[index] = Review(
          id: review.id,
          userId: review.userId,
          ritualId: review.ritualId,
          orderId: review.orderId,
          customerName: review.customerName,
          customerPhoto: review.customerPhoto,
          rating: review.rating,
          comment: review.comment,
          photos: review.photos,
          packageType: review.packageType,
          isVerified: review.isVerified,
          helpfulCount: review.helpfulCount + 1,
          reportCount: review.reportCount,
          date: review.date,
          lastEditedDate: review.lastEditedDate,
          recommended: review.recommended,
          aspects: review.aspects,
          adminResponse: review.adminResponse,
        );
      }
    }
    await _saveHelpfulReviews();
    notifyListeners();
  }

  bool isReviewHelpful(String reviewId) {
    return _helpfulReviews.contains(reviewId);
  }

  Future<void> reportReview(String reviewId, String reason) async {
    await Future.delayed(const Duration(seconds: 1));
    // In production, send to backend
    notifyListeners();
  }

  List<Review> _generateMockReviews() {
    return [
      // Ritual 1 reviews
      Review(
        id: 'REV001',
        userId: 'USER002',
        ritualId: '1',
        orderId: 'ORD001',
        customerName: 'Priya Sharma',
        customerPhoto: 'https://i.pravatar.cc/150?img=1',
        rating: 5.0,
        comment: 'Absolutely divine experience! The pandit performed the ritual with such devotion and explained every step. The live stream quality was excellent and I felt connected throughout. Highly recommended!',
        photos: [
          'https://images.unsplash.com/photo-1604608672516-f1b9b1b1c1c1',
          'https://images.unsplash.com/photo-1582510003544-4d00b7f74220',
        ],
        packageType: 'Family Package',
        isVerified: true,
        helpfulCount: 45,
        date: DateTime.now().subtract(const Duration(days: 5)),
        recommended: true,
        aspects: ReviewAspects(
          ritualAuthenticity: 5.0,
          priestInteraction: 5.0,
          liveStreamQuality: 4.5,
          aashirwadBoxQuality: 5.0,
        ),
      ),
      Review(
        id: 'REV002',
        userId: 'USER003',
        ritualId: '1',
        orderId: 'ORD002',
        customerName: 'Rajesh Kumar',
        customerPhoto: 'https://i.pravatar.cc/150?img=12',
        rating: 5.0,
        comment: 'The live streaming was crystal clear and I felt connected throughout. The prasad arrived fresh and the aashirwad box was beautifully packaged. Will definitely book again!',
        photos: [],
        packageType: 'Personal Package',
        isVerified: true,
        helpfulCount: 32,
        date: DateTime.now().subtract(const Duration(days: 12)),
        recommended: true,
        aspects: ReviewAspects(
          ritualAuthenticity: 5.0,
          priestInteraction: 4.5,
          liveStreamQuality: 5.0,
          aashirwadBoxQuality: 5.0,
        ),
        adminResponse: AdminResponse(
          responseText: 'Thank you for your wonderful feedback! We\'re delighted to hear about your positive experience.',
          responseDate: DateTime.now().subtract(const Duration(days: 11)),
          respondedBy: 'Mandir Mitra Team',
        ),
      ),
      Review(
        id: 'REV003',
        userId: 'USER004',
        ritualId: '1',
        customerName: 'Anita Desai',
        customerPhoto: 'https://i.pravatar.cc/150?img=5',
        rating: 4.0,
        comment: 'Great service overall. The aashirwad box was beautifully packaged with all sacred items. Only minor issue was slight delay in delivery but everything else was perfect.',
        photos: ['https://images.unsplash.com/photo-1609619385002-f40f5e5c73b0'],
        packageType: 'Shared Package',
        isVerified: true,
        helpfulCount: 18,
        date: DateTime.now().subtract(const Duration(days: 20)),
        recommended: true,
      ),
      Review(
        id: 'REV004',
        userId: 'USER005',
        ritualId: '1',
        customerName: 'Vikram Singh',
        customerPhoto: 'https://i.pravatar.cc/150?img=15',
        rating: 5.0,
        comment: 'This was my first online puja and it exceeded all expectations. The priest was very knowledgeable and the entire process was seamless.',
        photos: [],
        packageType: 'Family Package',
        isVerified: true,
        helpfulCount: 27,
        date: DateTime.now().subtract(const Duration(days: 30)),
        recommended: true,
      ),
      Review(
        id: 'REV005',
        userId: 'USER006',
        ritualId: '1',
        customerName: 'Meera Patel',
        customerPhoto: 'https://i.pravatar.cc/150?img=9',
        rating: 4.5,
        comment: 'Wonderful experience! The ritual was performed with great care and devotion. Highly satisfied with the service.',
        photos: [],
        packageType: 'Personal Package',
        isVerified: false,
        helpfulCount: 12,
        date: DateTime.now().subtract(const Duration(days: 45)),
        recommended: true,
      ),
      Review(
        id: 'REV006',
        userId: 'USER007',
        ritualId: '1',
        customerName: 'Amit Verma',
        customerPhoto: 'https://i.pravatar.cc/150?img=13',
        rating: 3.0,
        comment: 'Service was okay. The ritual was performed well but the live stream had some connectivity issues. Could be better.',
        photos: [],
        packageType: 'Shared Package',
        isVerified: true,
        helpfulCount: 5,
        date: DateTime.now().subtract(const Duration(days: 60)),
        recommended: false,
      ),
    ];
  }
}
