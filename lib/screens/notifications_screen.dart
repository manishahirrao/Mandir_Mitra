import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_provider.dart';
import '../models/notification.dart';
import '../widgets/notifications/notification_card.dart';
import '../utils/app_theme.dart';
import 'notification_preferences_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false).markAllAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPreferencesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          final notifications = _selectedFilter == null
              ? provider.notifications
              : provider.getNotificationsByType(_selectedFilter);

          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: provider.refreshNotifications,
            child: Column(
              children: [
                _buildFilterChips(),
                Expanded(
                  child: _buildGroupedList(provider.groupedNotifications),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'label': 'All', 'type': null},
      {'label': 'Bookings', 'type': NotificationType.bookingConfirmation},
      {'label': 'Payments', 'type': NotificationType.paymentSuccess},
      {'label': 'Delivery', 'type': NotificationType.deliveryUpdate},
      {'label': 'Promotions', 'type': NotificationType.promotional},
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter['type'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter['label'] as String),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = selected ? filter['type'] as NotificationType? : null;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppTheme.sacredBlue.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.sacredBlue : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppTheme.sacredBlue : Colors.grey[300]!,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupedList(Map<String, List<AppNotification>> groups) {
    final groupOrder = ['Today', 'Yesterday', 'This Week', 'Older'];
    final sortedGroups = groupOrder.where((g) => groups.containsKey(g)).toList();

    return ListView.builder(
      itemCount: sortedGroups.length,
      itemBuilder: (context, index) {
        final group = sortedGroups[index];
        final notifications = groups[group]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                group,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ...notifications.map((notification) {
              return NotificationCard(
                notification: notification,
                onTap: () => _handleNotificationTap(notification),
                onDelete: () => _handleDelete(notification.id),
                onAction: notification.actionType != null
                    ? () => _handleAction(notification)
                    : null,
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you when something arrives',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(AppNotification notification) {
    Provider.of<NotificationProvider>(context, listen: false)
        .markAsRead(notification.id);
    
    if (notification.actionType != null) {
      _handleAction(notification);
    }
  }

  void _handleDelete(String notificationId) {
    Provider.of<NotificationProvider>(context, listen: false)
        .deleteNotification(notificationId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification deleted')),
    );
  }

  void _handleAction(AppNotification notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Action: ${notification.actionType}')),
    );
  }
}
