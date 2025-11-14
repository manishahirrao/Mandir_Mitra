import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification.dart';

class NotificationProvider with ChangeNotifier {
  List<AppNotification> _notifications = [];
  Map<String, bool> _preferences = {};

  NotificationProvider() {
    _loadMockNotifications();
    _loadPreferences();
  }

  List<AppNotification> get notifications => _notifications;
  
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  List<AppNotification> getNotificationsByType(NotificationType? type) {
    if (type == null) return _notifications;
    return _notifications.where((n) => n.type == type).toList();
  }

  Map<String, List<AppNotification>> get groupedNotifications {
    final groups = <String, List<AppNotification>>{};
    for (var notification in _notifications) {
      final group = notification.getGroupLabel();
      if (!groups.containsKey(group)) {
        groups[group] = [];
      }
      groups[group]!.add(notification);
    }
    return groups;
  }

  void _loadMockNotifications() {
    _notifications = [
      AppNotification(
        id: 'N001',
        type: NotificationType.liveStream,
        title: 'Your ritual is starting now!',
        description: 'Satyanarayan Puja at Shri Jagannath Temple. Join the live stream.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        actionType: 'view_stream',
        actionData: {'orderId': 'ORD001'},
      ),
      AppNotification(
        id: 'N002',
        type: NotificationType.deliveryUpdate,
        title: 'Your Aashirwad Box will arrive today',
        description: 'Expected delivery between 10 AM - 2 PM. Track your order.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        actionType: 'track_order',
        actionData: {'orderId': 'ORD001'},
      ),
      AppNotification(
        id: 'N003',
        type: NotificationType.ritualReminder,
        title: 'Ritual reminder',
        description: 'Your Griha Pravesh Puja is tomorrow at 10:00 AM.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
        actionType: 'view_order',
        actionData: {'orderId': 'ORD002'},
      ),
      AppNotification(
        id: 'N004',
        type: NotificationType.paymentSuccess,
        title: 'Payment successful',
        description: 'Payment of ₹5,100 received. Order #ORD002 confirmed.',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        isRead: true,
        actionType: 'view_order',
        actionData: {'orderId': 'ORD002'},
      ),
      AppNotification(
        id: 'N005',
        type: NotificationType.promotional,
        title: 'Special discount: 20% off',
        description: 'Get 20% off on all rituals this weekend. Limited time offer!',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        isRead: false,
        actionType: 'view_services',
      ),
      AppNotification(
        id: 'N006',
        type: NotificationType.aashirwadBoxShipped,
        title: 'Your Aashirwad Box has been shipped',
        description: 'Track your order with tracking ID: TRACK123456',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 10)),
        isRead: true,
        actionType: 'track_order',
        actionData: {'orderId': 'ORD003', 'trackingId': 'TRACK123456'},
      ),
      AppNotification(
        id: 'N007',
        type: NotificationType.reviewRequest,
        title: 'How was your experience?',
        description: 'Rate your Lakshmi Puja ritual and help others.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        actionType: 'write_review',
        actionData: {'orderId': 'ORD003'},
      ),
      AppNotification(
        id: 'N008',
        type: NotificationType.bookingConfirmation,
        title: 'Booking confirmed',
        description: 'Your Rudrabhishek ritual is confirmed for 25 Dec 2024.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
        actionType: 'view_order',
        actionData: {'orderId': 'ORD004'},
      ),
      AppNotification(
        id: 'N009',
        type: NotificationType.deliveryUpdate,
        title: 'Aashirwad Box delivered',
        description: 'Your order has been delivered successfully.',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        isRead: true,
        actionType: 'view_order',
        actionData: {'orderId': 'ORD004'},
      ),
      AppNotification(
        id: 'N010',
        type: NotificationType.promotional,
        title: 'New ritual added',
        description: 'Navratri Special Puja now available. Book now!',
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        isRead: true,
        actionType: 'view_services',
      ),
    ];
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _preferences = {
      'booking_confirmations': prefs.getBool('notif_booking_confirmations') ?? true,
      'ritual_reminders': prefs.getBool('notif_ritual_reminders') ?? true,
      'rescheduling_updates': prefs.getBool('notif_rescheduling_updates') ?? true,
      'cancellation_confirmations': prefs.getBool('notif_cancellation_confirmations') ?? true,
      'payment_confirmations': prefs.getBool('notif_payment_confirmations') ?? true,
      'invoice_generation': prefs.getBool('notif_invoice_generation') ?? true,
      'refund_updates': prefs.getBool('notif_refund_updates') ?? true,
      'box_dispatch': prefs.getBool('notif_box_dispatch') ?? true,
      'out_for_delivery': prefs.getBool('notif_out_for_delivery') ?? true,
      'delivery_confirmation': prefs.getBool('notif_delivery_confirmation') ?? true,
      'stream_starting': prefs.getBool('notif_stream_starting') ?? true,
      'stream_recording': prefs.getBool('notif_stream_recording') ?? true,
      'special_offers': prefs.getBool('notif_special_offers') ?? true,
      'new_rituals': prefs.getBool('notif_new_rituals') ?? true,
      'festival_greetings': prefs.getBool('notif_festival_greetings') ?? true,
      'push_notifications': prefs.getBool('notif_push_notifications') ?? true,
      'email': prefs.getBool('notif_email') ?? true,
      'sms': prefs.getBool('notif_sms') ?? true,
      'whatsapp': prefs.getBool('notif_whatsapp') ?? false,
      'quiet_hours_enabled': prefs.getBool('notif_quiet_hours_enabled') ?? false,
    };
    notifyListeners();
  }

  bool getPreference(String key) {
    return _preferences[key] ?? true;
  }

  Future<void> setPreference(String key, bool value) async {
    _preferences[key] = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_$key', value);
    notifyListeners();
  }

  Future<void> saveAllPreferences(Map<String, bool> preferences) async {
    _preferences = preferences;
    final prefs = await SharedPreferences.getInstance();
    for (var entry in preferences.entries) {
      await prefs.setBool('notif_${entry.key}', entry.value);
    }
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();
  }

  Future<void> refreshNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }
}
