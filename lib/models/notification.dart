enum NotificationType {
  bookingConfirmation,
  ritualReminder,
  liveStream,
  paymentSuccess,
  aashirwadBoxShipped,
  deliveryUpdate,
  promotional,
  reviewRequest,
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isRead;
  final String? actionType;
  final Map<String, dynamic>? actionData;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
    this.actionType,
    this.actionData,
  });

  AppNotification copyWith({
    bool? isRead,
  }) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      description: description,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      actionType: actionType,
      actionData: actionData,
    );
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String getGroupLabel() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < 24 && now.day == timestamp.day) {
      return 'Today';
    } else if (difference.inDays == 1 || (difference.inHours < 48 && now.day - timestamp.day == 1)) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return 'This Week';
    } else {
      return 'Older';
    }
  }
}
