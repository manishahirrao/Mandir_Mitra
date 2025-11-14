class Review {
  final String id;
  final String userId;
  final String ritualId;
  final String? orderId;
  final String customerName;
  final String customerPhoto;
  final double rating;
  final String comment;
  final List<String> photos;
  final String? packageType;
  final bool isVerified;
  final int helpfulCount;
  final int reportCount;
  final DateTime date;
  final DateTime? lastEditedDate;
  final bool recommended;
  final ReviewAspects? aspects;
  final AdminResponse? adminResponse;

  Review({
    required this.id,
    required this.userId,
    required this.ritualId,
    this.orderId,
    required this.customerName,
    required this.customerPhoto,
    required this.rating,
    required this.comment,
    this.photos = const [],
    this.packageType,
    this.isVerified = false,
    this.helpfulCount = 0,
    this.reportCount = 0,
    required this.date,
    this.lastEditedDate,
    this.recommended = true,
    this.aspects,
    this.adminResponse,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'ritualId': ritualId,
      'orderId': orderId,
      'customerName': customerName,
      'customerPhoto': customerPhoto,
      'rating': rating,
      'comment': comment,
      'photos': photos,
      'packageType': packageType,
      'isVerified': isVerified,
      'helpfulCount': helpfulCount,
      'reportCount': reportCount,
      'date': date.toIso8601String(),
      'lastEditedDate': lastEditedDate?.toIso8601String(),
      'recommended': recommended,
      'aspects': aspects?.toJson(),
      'adminResponse': adminResponse?.toJson(),
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      ritualId: json['ritualId'],
      orderId: json['orderId'],
      customerName: json['customerName'],
      customerPhoto: json['customerPhoto'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      photos: List<String>.from(json['photos'] ?? []),
      packageType: json['packageType'],
      isVerified: json['isVerified'] ?? false,
      helpfulCount: json['helpfulCount'] ?? 0,
      reportCount: json['reportCount'] ?? 0,
      date: DateTime.parse(json['date']),
      lastEditedDate: json['lastEditedDate'] != null
          ? DateTime.parse(json['lastEditedDate'])
          : null,
      recommended: json['recommended'] ?? true,
      aspects: json['aspects'] != null
          ? ReviewAspects.fromJson(json['aspects'])
          : null,
      adminResponse: json['adminResponse'] != null
          ? AdminResponse.fromJson(json['adminResponse'])
          : null,
    );
  }
}

class ReviewAspects {
  final double ritualAuthenticity;
  final double priestInteraction;
  final double liveStreamQuality;
  final double aashirwadBoxQuality;

  ReviewAspects({
    required this.ritualAuthenticity,
    required this.priestInteraction,
    required this.liveStreamQuality,
    required this.aashirwadBoxQuality,
  });

  Map<String, dynamic> toJson() {
    return {
      'ritualAuthenticity': ritualAuthenticity,
      'priestInteraction': priestInteraction,
      'liveStreamQuality': liveStreamQuality,
      'aashirwadBoxQuality': aashirwadBoxQuality,
    };
  }

  factory ReviewAspects.fromJson(Map<String, dynamic> json) {
    return ReviewAspects(
      ritualAuthenticity: json['ritualAuthenticity'].toDouble(),
      priestInteraction: json['priestInteraction'].toDouble(),
      liveStreamQuality: json['liveStreamQuality'].toDouble(),
      aashirwadBoxQuality: json['aashirwadBoxQuality'].toDouble(),
    );
  }
}

class AdminResponse {
  final String responseText;
  final DateTime responseDate;
  final String respondedBy;

  AdminResponse({
    required this.responseText,
    required this.responseDate,
    required this.respondedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'responseText': responseText,
      'responseDate': responseDate.toIso8601String(),
      'respondedBy': respondedBy,
    };
  }

  factory AdminResponse.fromJson(Map<String, dynamic> json) {
    return AdminResponse(
      responseText: json['responseText'],
      responseDate: DateTime.parse(json['responseDate']),
      respondedBy: json['respondedBy'],
    );
  }
}

class RatingDistribution {
  final int fiveStars;
  final int fourStars;
  final int threeStars;
  final int twoStars;
  final int oneStar;

  RatingDistribution({
    required this.fiveStars,
    required this.fourStars,
    required this.threeStars,
    required this.twoStars,
    required this.oneStar,
  });

  int get total =>
      fiveStars + fourStars + threeStars + twoStars + oneStar;

  double get fiveStarPercentage => total > 0 ? (fiveStars / total) * 100 : 0;
  double get fourStarPercentage => total > 0 ? (fourStars / total) * 100 : 0;
  double get threeStarPercentage =>
      total > 0 ? (threeStars / total) * 100 : 0;
  double get twoStarPercentage => total > 0 ? (twoStars / total) * 100 : 0;
  double get oneStarPercentage => total > 0 ? (oneStar / total) * 100 : 0;
}
