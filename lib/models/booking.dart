enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
}

class Booking {
  final String id;
  final String ritualId;
  final String ritualName;
  final String ritualImage;
  final String userId;
  final String templeName;
  final String templeLocation;
  final String packageType;
  final int participants;
  final DateTime scheduledDateTime;
  final String? priestId;
  final String? priestName;
  final String specialRequests;
  final bool includeAashirwadBox;
  final List<String> addOnItems;
  final String? deliveryAddressId;
  final double basePrice;
  final double aashirwadBoxPrice;
  final double addOnsPrice;
  final double taxAmount;
  final double totalAmount;
  final PaymentStatus paymentStatus;
  final String? paymentMethod;
  final String? transactionId;
  final BookingStatus status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.ritualId,
    required this.ritualName,
    required this.ritualImage,
    required this.userId,
    required this.templeName,
    required this.templeLocation,
    required this.packageType,
    required this.participants,
    required this.scheduledDateTime,
    this.priestId,
    this.priestName,
    this.specialRequests = '',
    this.includeAashirwadBox = true,
    this.addOnItems = const [],
    this.deliveryAddressId,
    required this.basePrice,
    this.aashirwadBoxPrice = 0,
    this.addOnsPrice = 0,
    required this.taxAmount,
    required this.totalAmount,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentMethod,
    this.transactionId,
    this.status = BookingStatus.pending,
    required this.createdAt,
  });

  Booking copyWith({
    PaymentStatus? paymentStatus,
    String? paymentMethod,
    String? transactionId,
    BookingStatus? status,
  }) {
    return Booking(
      id: id,
      ritualId: ritualId,
      ritualName: ritualName,
      ritualImage: ritualImage,
      userId: userId,
      templeName: templeName,
      templeLocation: templeLocation,
      packageType: packageType,
      participants: participants,
      scheduledDateTime: scheduledDateTime,
      priestId: priestId,
      priestName: priestName,
      specialRequests: specialRequests,
      includeAashirwadBox: includeAashirwadBox,
      addOnItems: addOnItems,
      deliveryAddressId: deliveryAddressId,
      basePrice: basePrice,
      aashirwadBoxPrice: aashirwadBoxPrice,
      addOnsPrice: addOnsPrice,
      taxAmount: taxAmount,
      totalAmount: totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
