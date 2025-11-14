import 'package:flutter/material.dart';
import '../../models/notification.dart';
import '../../utils/app_theme.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onAction;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
    this.onAction,
  });

  IconData _getIcon() {
    switch (notification.type) {
      case NotificationType.bookingConfirmation:
        return Icons.check_circle;
      case NotificationType.ritualReminder:
        return Icons.alarm;
      case NotificationType.liveStream:
        return Icons.videocam;
      case NotificationType.paymentSuccess:
        return Icons.payment;
      case NotificationType.aashirwadBoxShipped:
        return Icons.local_shipping;
      case NotificationType.deliveryUpdate:
        return Icons.delivery_dining;
      case NotificationType.promotional:
        return Icons.local_offer;
      case NotificationType.reviewRequest:
        return Icons.rate_review;
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case NotificationType.bookingConfirmation:
        return AppTheme.successGreen;
      case NotificationType.ritualReminder:
        return AppTheme.warningAmber;
      case NotificationType.liveStream:
        return AppTheme.errorRed;
      case NotificationType.paymentSuccess:
        return AppTheme.successGreen;
      case NotificationType.aashirwadBoxShipped:
        return AppTheme.sacredBlue;
      case NotificationType.deliveryUpdate:
        return AppTheme.sacredBlue;
      case NotificationType.promotional:
        return AppTheme.divineGold;
      case NotificationType.reviewRequest:
        return AppTheme.templeBrown;
    }
  }

  String? _getActionLabel() {
    if (notification.actionType == null) return null;
    switch (notification.actionType) {
      case 'view_order':
        return 'View Order';
      case 'track_order':
        return 'Track Box';
      case 'view_stream':
        return 'Join Stream';
      case 'write_review':
        return 'Write Review';
      case 'view_services':
        return 'Book Now';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppTheme.errorRed,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : AppTheme.sacredBlue.withOpacity(0.05),
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6, right: 12),
                  decoration: const BoxDecoration(
                    color: AppTheme.sacredBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getIconColor().withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIcon(), color: _getIconColor(), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                        color: AppTheme.templeBrown,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.description,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.getTimeAgo(),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    if (_getActionLabel() != null) ...[
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: onAction,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          side: BorderSide(color: _getIconColor()),
                          minimumSize: Size.zero,
                        ),
                        child: Text(
                          _getActionLabel()!,
                          style: TextStyle(fontSize: 12, color: _getIconColor()),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
