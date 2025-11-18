import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../config/razorpay_config.dart';

class RazorpayService {
  late Razorpay _razorpay;
  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onFailure;

  void initialize() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    onSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onFailure?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payment
  }

  Future<void> openCheckout({
    required String orderId,
    required double amount,
    required String name,
    required String email,
    required String phone,
    String? description,
  }) async {
    final options = {
      'key': RazorpayConfig.keyId,
      'amount': (amount * 100).toInt(), // Convert to paise
      'name': RazorpayConfig.companyName,
      'order_id': orderId,
      'description': description ?? 'Ritual Booking',
      'prefill': {
        'contact': phone,
        'email': email,
        'name': name,
      },
      'theme': {
        'color': RazorpayConfig.themeColor,
      },
      'method': {
        'netbanking': true,
        'card': true,
        'wallet': true,
        'upi': true,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      throw Exception('Failed to open Razorpay: $e');
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
