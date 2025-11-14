import 'package:flutter/foundation.dart';
import '../models/payment.dart';
import '../models/booking.dart';

class PaymentProvider with ChangeNotifier {
  bool _isProcessing = false;
  PaymentResult? _lastResult;

  bool get isProcessing => _isProcessing;
  PaymentResult? get lastResult => _lastResult;

  Future<PaymentResult> processPayment({
    required Booking booking,
    required PaymentMethod method,
    Map<String, dynamic>? paymentDetails,
  }) async {
    _isProcessing = true;
    _lastResult = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    final random = DateTime.now().millisecond;
    final success = random % 10 != 0;

    if (success) {
      final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
      _lastResult = PaymentResult(
        success: true,
        transactionId: transactionId,
      );
    } else {
      _lastResult = PaymentResult(
        success: false,
        errorMessage: 'Transaction declined by bank. Please try again.',
      );
    }

    _isProcessing = false;
    notifyListeners();

    return _lastResult!;
  }

  Future<bool> verifyPayment(String transactionId) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  String getPaymentStatus(String transactionId) {
    return 'completed';
  }

  void clearLastResult() {
    _lastResult = null;
    notifyListeners();
  }
}
