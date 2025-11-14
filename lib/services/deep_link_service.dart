import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkService {
  static StreamSubscription? _sub;

  static Future<void> initialize(BuildContext context) async {
    // Handle initial link if app was opened from a deep link
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(context, initialLink);
      }
    } catch (e) {
      debugPrint('Error getting initial link: $e');
    }

    // Listen for deep links while app is running
    _sub = linkStream.listen(
      (String? link) {
        if (link != null) {
          _handleDeepLink(context, link);
        }
      },
      onError: (err) {
        debugPrint('Deep link error: $err');
      },
    );
  }

  static void _handleDeepLink(BuildContext context, String link) {
    final uri = Uri.parse(link);
    
    // mandirmitra://ritual/[id]
    if (uri.host == 'ritual' && uri.pathSegments.isNotEmpty) {
      final ritualId = uri.pathSegments[0];
      Navigator.pushNamed(
        context,
        '/ritual-detail',
        arguments: {'ritualId': ritualId},
      );
    }
    
    // mandirmitra://order/[id]
    else if (uri.host == 'order' && uri.pathSegments.isNotEmpty) {
      final orderId = uri.pathSegments[0];
      Navigator.pushNamed(
        context,
        '/order-detail',
        arguments: {'orderId': orderId},
      );
    }
    
    // mandirmitra://referral/[code]
    else if (uri.host == 'referral' && uri.pathSegments.isNotEmpty) {
      final referralCode = uri.pathSegments[0];
      Navigator.pushNamed(
        context,
        '/referral',
        arguments: {'code': referralCode},
      );
    }
    
    // mandirmitra://notification/[type]/[id]
    else if (uri.host == 'notification' && uri.pathSegments.length >= 2) {
      final type = uri.pathSegments[0];
      final id = uri.pathSegments[1];
      
      switch (type) {
        case 'order':
          Navigator.pushNamed(
            context,
            '/order-detail',
            arguments: {'orderId': id},
          );
          break;
        case 'ritual':
          Navigator.pushNamed(
            context,
            '/ritual-detail',
            arguments: {'ritualId': id},
          );
          break;
        case 'tracking':
          Navigator.pushNamed(
            context,
            '/tracking',
            arguments: {'orderId': id},
          );
          break;
        case 'stream':
          Navigator.pushNamed(
            context,
            '/live-stream',
            arguments: {'streamId': id},
          );
          break;
        default:
          Navigator.pushNamed(context, '/notifications');
      }
    }
    
    // mandirmitra://stream/[id]
    else if (uri.host == 'stream' && uri.pathSegments.isNotEmpty) {
      final streamId = uri.pathSegments[0];
      Navigator.pushNamed(
        context,
        '/live-stream',
        arguments: {'streamId': streamId},
      );
    }
    
    // Default: go to home
    else {
      Navigator.pushNamed(context, '/main');
    }
  }

  static void dispose() {
    _sub?.cancel();
  }
}
