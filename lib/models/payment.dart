enum PaymentMethod {
  upi,
  card,
  netBanking,
  wallet,
  payAtTemple,
}

class Payment {
  final String id;
  final String bookingId;
  final double amount;
  final PaymentMethod method;
  final String? transactionId;
  final String status;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  Payment({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.method,
    this.transactionId,
    required this.status,
    required this.timestamp,
    this.metadata,
  });
}

class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;

  PaymentResult({
    required this.success,
    this.transactionId,
    this.errorMessage,
  });
}
