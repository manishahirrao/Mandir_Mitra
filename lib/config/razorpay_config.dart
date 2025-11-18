class RazorpayConfig {
  // TODO: Replace with your Razorpay credentials
  // Test keys (for development)
  static const String testKeyId = 'rzp_test_xxxxx';
  static const String testKeySecret = 'xxxxx';
  
  // Live keys (for production)
  static const String liveKeyId = 'rzp_live_xxxxx';
  static const String liveKeySecret = 'xxxxx';
  
  // Use test or live based on environment
  static const bool isProduction = false;
  
  static String get keyId => isProduction ? liveKeyId : testKeyId;
  static String get keySecret => isProduction ? liveKeySecret : testKeySecret;
  
  // Company details
  static const String companyName = 'Mandir Mitra';
  static const String companyLogo = 'https://your-logo-url.com/logo.png';
  static const String themeColor = '#FF6B35';
  
  // Payment options
  static const String currency = 'INR';
  static const List<String> paymentMethods = [
    'card',
    'netbanking',
    'wallet',
    'upi',
  ];
}
