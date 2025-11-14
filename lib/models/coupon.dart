enum DiscountType {
  percentage,
  flat,
}

enum CouponStatus {
  active,
  used,
  expired,
}

class Coupon {
  final String code;
  final String name;
  final String description;
  final DiscountType discountType;
  final double discountValue;
  final double minOrderValue;
  final DateTime validFrom;
  final DateTime validTill;
  final int usageLimit;
  final int usedCount;
  final CouponStatus status;
  final String? usedOn;
  final String? orderId;
  final List<String>? termsAndConditions;

  Coupon({
    required this.code,
    required this.name,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.minOrderValue,
    required this.validFrom,
    required this.validTill,
    required this.usageLimit,
    this.usedCount = 0,
    required this.status,
    this.usedOn,
    this.orderId,
    this.termsAndConditions,
  });

  bool get isValid {
    final now = DateTime.now();
    return status == CouponStatus.active &&
        now.isAfter(validFrom) &&
        now.isBefore(validTill) &&
        usedCount < usageLimit;
  }

  bool canApplyTo(double orderAmount) {
    return isValid && orderAmount >= minOrderValue;
  }

  double calculateDiscount(double orderAmount) {
    if (!canApplyTo(orderAmount)) return 0;
    
    if (discountType == DiscountType.percentage) {
      return (orderAmount * discountValue) / 100;
    } else {
      return discountValue;
    }
  }

  String getDiscountText() {
    if (discountType == DiscountType.percentage) {
      return '${discountValue.toInt()}% OFF';
    } else {
      return '₹${discountValue.toInt()} OFF';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'discountType': discountType.toString(),
      'discountValue': discountValue,
      'minOrderValue': minOrderValue,
      'validFrom': validFrom.toIso8601String(),
      'validTill': validTill.toIso8601String(),
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'status': status.toString(),
      'usedOn': usedOn,
      'orderId': orderId,
      'termsAndConditions': termsAndConditions,
    };
  }

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      code: json['code'],
      name: json['name'],
      description: json['description'],
      discountType: DiscountType.values.firstWhere(
        (e) => e.toString() == json['discountType'],
      ),
      discountValue: json['discountValue'].toDouble(),
      minOrderValue: json['minOrderValue'].toDouble(),
      validFrom: DateTime.parse(json['validFrom']),
      validTill: DateTime.parse(json['validTill']),
      usageLimit: json['usageLimit'],
      usedCount: json['usedCount'] ?? 0,
      status: CouponStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      usedOn: json['usedOn'],
      orderId: json['orderId'],
      termsAndConditions: json['termsAndConditions'] != null
          ? List<String>.from(json['termsAndConditions'])
          : null,
    );
  }
}
