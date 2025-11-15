import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Comprehensive Design System for Mandir Mitra App
/// Implements color strategy, typography, spacing, and animation guidelines
class AppTheme {
  // ============================================================================
  // COLOR PALETTE
  // ============================================================================
  
  /// Primary Colors
  static const Color primaryBlue = Color(0xFF004C99);
  static const Color sacredBlue = Color(0xFF004C99);
  static const Color divineGold = Color(0xFFD4AF37);
  static const Color goldenAccent = Color(0xFFD4AF37);
  
  /// Background Colors
  static const Color templeCream = Color(0xFFFAF9F6);
  static const Color sacredWhite = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  /// Accent Colors
  static const Color holyRed = Color(0xFFD32F2F);
  static const Color saffronYellow = Color(0xFFFF9933);
  static const Color templeBrown = Color(0xFF5D4037);
  static const Color earthTones = Color(0xFF6B5A3E);
  static const Color gangajalBlue = Color(0xFF00A3E0);
  
  /// Semantic Colors
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color warningAmber = Color(0xFFF57C00);
  
  /// Neutral Colors
  static const Color sacredGrey = Color(0xFF333333);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color dividerGrey = Color(0xFFBDBDBD);
  
  /// Orange Colors (for compatibility)
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color secondaryOrange = Color(0xFFFF8C42);
  
  // ============================================================================
  // GRADIENTS
  // ============================================================================
  
  /// Divine Gold Gradient (Primary CTAs)
  static const LinearGradient divineGoldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFF4D03F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Sacred Blue Gradient
  static const LinearGradient sacredGradient = LinearGradient(
    colors: [sacredBlue, Color(0xFF0066CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Peaceful Gradient
  static const LinearGradient peacefulGradient = LinearGradient(
    colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Saffron Gradient
  static const LinearGradient saffronGradient = LinearGradient(
    colors: [Color(0xFFFF9933), Color(0xFFFFB366)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ============================================================================
  // SHADOWS
  // ============================================================================
  
  /// Card Shadow (Subtle)
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
  
  /// Elevated Shadow (Medium)
  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
  
  /// Divine Gold Shadow (for CTAs)
  static List<BoxShadow> get divineGoldShadow => [
        BoxShadow(
          color: divineGold.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
  
  /// Hover Shadow (Lift effect)
  static List<BoxShadow> get hoverShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
  
  // ============================================================================
  // SPACING SYSTEM
  // ============================================================================
  
  /// Tight spacing (8px)
  static const double spaceTight = 8.0;
  
  /// Standard spacing (16px)
  static const double spaceStandard = 16.0;
  
  /// Loose spacing (24px)
  static const double spaceLoose = 24.0;
  
  /// Section spacing (32px vertical)
  static const double sectionSpacing = 32.0;
  
  /// Card padding (16px)
  static const double cardPadding = 16.0;
  
  /// Legacy spacing constants
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;
  
  // ============================================================================
  // BORDER RADIUS
  // ============================================================================
  
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusFull = 999.0;
  
  // ============================================================================
  // CONTAINER WIDTHS (Responsive)
  // ============================================================================
  
  static const double mobileMaxWidth = double.infinity;
  static const double tabletMaxWidth = 720.0;
  static const double desktopMaxWidth = 1200.0;
  
  // ============================================================================
  // TYPOGRAPHY
  // ============================================================================
  
  /// Headings - Playfair Display
  static TextStyle get h1 => GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        height: 1.2,
      );
  
  static TextStyle get h1Desktop => GoogleFonts.playfairDisplay(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        height: 1.2,
      );
  
  static TextStyle get h2 => GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      );
  
  static TextStyle get h2Desktop => GoogleFonts.playfairDisplay(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      );
  
  /// Subheadings - Montserrat
  static TextStyle get h3 => GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      );
  
  static TextStyle get h3Desktop => GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      );
  
  static TextStyle get h4 => GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        height: 1.4,
      );
  
  static TextStyle get h4Desktop => GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        height: 1.4,
      );
  
  /// Body Text - Inter
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.5,
      );
  
  static TextStyle get bodyBase => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.5,
      );
  
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.5,
      );
  
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.4,
      );
  
  /// Special Text Styles
  static TextStyle get buttonText => GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.7, // 0.05em
        height: 1.2,
      );
  
  static TextStyle get priceText => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        height: 1.2,
      );
  
  static TextStyle get priceLarge => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        height: 1.2,
      );
  
  /// Sacred Text - Noto Sans Devanagari
  static TextStyle get sacredText => GoogleFonts.notoSansDevanagari(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.6,
      );
  
  static TextStyle get mantraText => GoogleFonts.notoSansDevanagari(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: sacredBlue,
        height: 1.8,
      );
  
  // ============================================================================
  // ANIMATION DURATIONS
  // ============================================================================
  
  /// Micro-interactions
  static const Duration buttonPressDuration = Duration(milliseconds: 150);
  static const Duration cardHoverDuration = Duration(milliseconds: 250);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration modalOpenDuration = Duration(milliseconds: 250);
  
  /// Standard durations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration normalAnimation = Duration(milliseconds: 250);
  static const Duration slowAnimation = Duration(milliseconds: 300);
  
  // ============================================================================
  // ANIMATION CURVES
  // ============================================================================
  
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeIn = Curves.easeIn;
  
  // ============================================================================
  // STATUS COLORS
  // ============================================================================
  
  /// Status: Completed
  static const Color statusCompleted = successGreen;
  static const Color statusCompletedBg = Color(0xFFE8F5E9);
  
  /// Status: Pending/Upcoming
  static const Color statusPending = warningAmber;
  static const Color statusPendingBg = Color(0xFFFFF3E0);
  
  /// Status: Cancelled
  static const Color statusCancelled = errorRed;
  static const Color statusCancelledBg = Color(0xFFFFEBEE);
  
  /// Status: Live Now
  static const Color statusLive = holyRed;
  
  // ============================================================================
  // THEME DATA
  // ============================================================================
  
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    
    // Color Scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: sacredBlue,
      primary: sacredBlue,
      secondary: divineGold,
      error: errorRed,
      background: templeCream,
      surface: sacredWhite,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: templeCream,
    
    // App Bar
    appBarTheme: AppBarTheme(
      backgroundColor: sacredBlue,
      foregroundColor: sacredWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: sacredWhite,
      ),
    ),
    
    // Card
    cardTheme: CardThemeData(
      color: sacredWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        side: const BorderSide(color: templeCream, width: 1),
      ),
      shadowColor: Colors.black.withOpacity(0.08),
    ),
    
    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: sacredBlue,
        foregroundColor: sacredWhite,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        elevation: 2,
        textStyle: buttonText,
      ),
    ),
    
    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: sacredBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: buttonText,
      ),
    ),
    
    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: sacredBlue,
        side: const BorderSide(color: sacredBlue, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        textStyle: buttonText,
      ),
    ),
    
    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: sacredWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: borderGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: borderGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: sacredBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: textSecondary,
      ),
    ),
    
    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: sacredWhite,
      selectedItemColor: divineGold,
      unselectedItemColor: sacredGrey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // Divider
    dividerTheme: const DividerThemeData(
      color: dividerGrey,
      thickness: 1,
      space: 1,
    ),
    
    // Text Theme
    textTheme: TextTheme(
      displayLarge: h1,
      displayMedium: h2,
      displaySmall: h3,
      headlineMedium: h4,
      bodyLarge: bodyLarge,
      bodyMedium: bodyBase,
      bodySmall: bodySmall,
      labelLarge: buttonText,
      labelSmall: caption,
    ),
  );
  
  // ============================================================================
  // HELPER METHODS
  // ============================================================================
  
  /// Get responsive padding based on screen width
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > desktopMaxWidth) {
      return const EdgeInsets.symmetric(horizontal: 48);
    } else if (width > tabletMaxWidth) {
      return const EdgeInsets.symmetric(horizontal: 32);
    }
    return const EdgeInsets.symmetric(horizontal: 16);
  }
  
  /// Get responsive text style
  static TextStyle getResponsiveH1(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > tabletMaxWidth ? h1Desktop : h1;
  }
  
  static TextStyle getResponsiveH2(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > tabletMaxWidth ? h2Desktop : h2;
  }
  
  /// Create a card decoration with standard styling
  static BoxDecoration cardDecoration({
    Color? color,
    List<BoxShadow>? shadows,
    Border? border,
  }) {
    return BoxDecoration(
      color: color ?? sacredWhite,
      borderRadius: BorderRadius.circular(radiusMD),
      border: border ?? Border.all(color: templeCream, width: 1),
      boxShadow: shadows ?? cardShadow,
    );
  }
  
  /// Create a gradient button decoration
  static BoxDecoration gradientButtonDecoration({
    Gradient? gradient,
    double radius = radiusMD,
  }) {
    return BoxDecoration(
      gradient: gradient ?? divineGoldGradient,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: divineGoldShadow,
    );
  }
  
  /// Create status badge decoration
  static BoxDecoration statusBadgeDecoration(String status) {
    Color bgColor;
    switch (status.toLowerCase()) {
      case 'completed':
        bgColor = statusCompletedBg;
        break;
      case 'pending':
      case 'upcoming':
        bgColor = statusPendingBg;
        break;
      case 'cancelled':
        bgColor = statusCancelledBg;
        break;
      default:
        bgColor = Colors.grey[100]!;
    }
    
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(radiusSM),
    );
  }
  
  /// Get status color
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return statusCompleted;
      case 'pending':
      case 'upcoming':
        return statusPending;
      case 'cancelled':
        return statusCancelled;
      case 'live':
        return statusLive;
      default:
        return textSecondary;
    }
  }
}
