import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/coupon.dart';

class CouponProvider with ChangeNotifier {
  List<Coupon> _coupons = [];
  Coupon? _appliedCoupon;
  bool _isLoading = false;

  CouponProvider() {
    _loadCoupons();
  }

  List<Coupon> get coupons => _coupons;
  Coupon? get appliedCoupon => _appliedCoupon;
  bool get isLoading => _isLoading;

  List<Coupon> get activeCoupons =>
      _coupons.where((c) => c.status == CouponStatus.active).toList();

  List<Coupon> get usedCoupons =>
      _coupons.where((c) => c.status == CouponStatus.used).toList();

  List<Coupon> get expiredCoupons =>
      _coupons.where((c) => c.status == CouponStatus.expired).toList();

  Future<void> _loadCoupons() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final couponsJson = prefs.getString('coupons');
      
      if (couponsJson != null) {
        final List<dynamic> decoded = json.decode(couponsJson);
        _coupons = decoded.map((c) => Coupon.fromJson(c)).toList();
      } else {
        _generateMockCoupons();
      }
    } catch (e) {
      debugPrint('Error loading coupons: $e');
      _generateMockCoupons();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveCoupons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'coupons',
        json.encode(_coupons.map((c) => c.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error saving coupons: $e');
    }
  }

  void _generateMockCoupons() {
    final now = DateTime.now();
    _coupons = [
      Coupon(
        code: 'FIRST100',
        name: 'First Booking Offer',
        description: 'Get ₹100 off on your first booking',
        discountType: DiscountType.flat,
        discountValue: 100,
        minOrderValue: 500,
        validFrom: now.subtract(const Duration(days: 30)),
        validTill: now.add(const Duration(days: 30)),
        usageLimit: 1,
        status: CouponStatus.active,
        termsAndConditions: [
          'Valid on first booking only',
          'Minimum order value ₹500',
          'Cannot be combined with other offers',
        ],
      ),
      Coupon(
        code: 'SAVE20',
        name: '20% Off',
        description: 'Get 20% off on all rituals',
        discountType: DiscountType.percentage,
        discountValue: 20,
        minOrderValue: 1000,
        validFrom: now.subtract(const Duration(days: 15)),
        validTill: now.add(const Duration(days: 15)),
        usageLimit: 3,
        status: CouponStatus.active,
        termsAndConditions: [
          'Valid on all rituals',
          'Minimum order value ₹1000',
          'Maximum discount ₹500',
        ],
      ),
      Coupon(
        code: 'FESTIVAL50',
        name: 'Festival Special',
        description: 'Flat ₹50 off on any booking',
        discountType: DiscountType.flat,
        discountValue: 50,
        minOrderValue: 300,
        validFrom: now.subtract(const Duration(days: 60)),
        validTill: now.subtract(const Duration(days: 5)),
        usageLimit: 1,
        usedCount: 1,
        status: CouponStatus.used,
        usedOn: now.subtract(const Duration(days: 10)).toIso8601String(),
        orderId: 'ORD001',
        termsAndConditions: [
          'Valid on all bookings',
          'Minimum order value ₹300',
        ],
      ),
    ];
  }

  Future<Map<String, dynamic>> validateCoupon(String code, double orderAmount) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final coupon = _coupons.firstWhere(
      (c) => c.code.toUpperCase() == code.toUpperCase(),
      orElse: () => Coupon(
        code: '',
        name: '',
        description: '',
        discountType: DiscountType.flat,
        discountValue: 0,
        minOrderValue: 0,
        validFrom: DateTime.now(),
        validTill: DateTime.now(),
        usageLimit: 0,
        status: CouponStatus.expired,
      ),
    );

    if (coupon.code.isEmpty) {
      return {
        'valid': false,
        'message': 'Invalid coupon code',
      };
    }

    if (!coupon.isValid) {
      if (coupon.status == CouponStatus.expired) {
        return {
          'valid': false,
          'message': 'This coupon has expired',
        };
      }
      if (coupon.status == CouponStatus.used) {
        return {
          'valid': false,
          'message': 'This coupon has already been used',
        };
      }
      return {
        'valid': false,
        'message': 'This coupon is not valid',
      };
    }

    if (!coupon.canApplyTo(orderAmount)) {
      return {
        'valid': false,
        'message': 'Minimum order value is ₹${coupon.minOrderValue.toInt()}',
      };
    }

    final discount = coupon.calculateDiscount(orderAmount);
    return {
      'valid': true,
      'coupon': coupon,
      'discount': discount,
      'message': 'Coupon applied successfully! You saved ₹${discount.toInt()}',
    };
  }

  Future<void> applyCoupon(Coupon coupon) async {
    _appliedCoupon = coupon;
    notifyListeners();
  }

  void removeCoupon() {
    _appliedCoupon = null;
    notifyListeners();
  }

  Future<void> useCoupon(String code, String orderId) async {
    final index = _coupons.indexWhere(
      (c) => c.code.toUpperCase() == code.toUpperCase(),
    );

    if (index != -1) {
      _coupons[index] = Coupon(
        code: _coupons[index].code,
        name: _coupons[index].name,
        description: _coupons[index].description,
        discountType: _coupons[index].discountType,
        discountValue: _coupons[index].discountValue,
        minOrderValue: _coupons[index].minOrderValue,
        validFrom: _coupons[index].validFrom,
        validTill: _coupons[index].validTill,
        usageLimit: _coupons[index].usageLimit,
        usedCount: _coupons[index].usedCount + 1,
        status: CouponStatus.used,
        usedOn: DateTime.now().toIso8601String(),
        orderId: orderId,
        termsAndConditions: _coupons[index].termsAndConditions,
      );

      await _saveCoupons();
      _appliedCoupon = null;
      notifyListeners();
    }
  }

  Future<void> addCoupon(Coupon coupon) async {
    _coupons.add(coupon);
    await _saveCoupons();
    notifyListeners();
  }

  Future<void> generateCouponFromReward(String rewardId, int pointsSpent) async {
    final now = DateTime.now();
    String code, name, description;
    DiscountType type;
    double value;

    switch (rewardId) {
      case 'R001':
        code = 'LOYALTY${now.millisecondsSinceEpoch % 100000}';
        name = '₹100 OFF Reward';
        description = 'Redeemed with $pointsSpent loyalty points';
        type = DiscountType.flat;
        value = 100;
        break;
      case 'R002':
        code = 'UPGRADE${now.millisecondsSinceEpoch % 100000}';
        name = 'Free Aashirwad Box Upgrade';
        description = 'Redeemed with $pointsSpent loyalty points';
        type = DiscountType.flat;
        value = 0;
        break;
      default:
        code = 'REWARD${now.millisecondsSinceEpoch % 100000}';
        name = 'Loyalty Reward';
        description = 'Redeemed with $pointsSpent loyalty points';
        type = DiscountType.flat;
        value = 50;
    }

    final coupon = Coupon(
      code: code,
      name: name,
      description: description,
      discountType: type,
      discountValue: value,
      minOrderValue: 0,
      validFrom: now,
      validTill: now.add(const Duration(days: 30)),
      usageLimit: 1,
      status: CouponStatus.active,
      termsAndConditions: [
        'Valid for 30 days from redemption',
        'Cannot be combined with other offers',
        'Non-transferable',
      ],
    );

    await addCoupon(coupon);
  }
}
