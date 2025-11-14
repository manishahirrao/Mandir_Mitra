enum OrderStatus {
  upcoming,
  completed,
  cancelled,
}

enum AashirwadBoxStatus {
  prepared,
  shipped,
  delivered,
}

class OrderedRitual {
  final String id;
  final String ritualId;
  final String ritualName;
  final String ritualImage;
  final String templeName;
  final String templeLocation;
  final String packageType;
  final DateTime scheduledDate;
  final DateTime bookedDate;
  final OrderStatus status;
  final double totalPrice;
  final String priestName;
  final String priestPhoto;
  final String? liveStreamUrl;
  final AashirwadBoxStatus? boxStatus;
  final String? trackingNumber;
  final DateTime? expectedDeliveryDate;
  final String paymentMethod;
  final String transactionId;
  final bool hasReview;

  OrderedRitual({
    required this.id,
    required this.ritualId,
    required this.ritualName,
    required this.ritualImage,
    required this.templeName,
    required this.templeLocation,
    required this.packageType,
    required this.scheduledDate,
    required this.bookedDate,
    required this.status,
    required this.totalPrice,
    required this.priestName,
    required this.priestPhoto,
    this.liveStreamUrl,
    this.boxStatus,
    this.trackingNumber,
    this.expectedDeliveryDate,
    required this.paymentMethod,
    required this.transactionId,
    this.hasReview = false,
  });
}
