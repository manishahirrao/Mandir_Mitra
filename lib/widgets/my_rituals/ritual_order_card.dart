import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/ordered_ritual.dart';
import '../../utils/app_theme.dart';

class RitualOrderCard extends StatelessWidget {
  final OrderedRitual order;
  final VoidCallback onViewDetails;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;
  final VoidCallback? onReorder;
  final VoidCallback? onWriteReview;
  final VoidCallback? onRebook;

  const RitualOrderCard({
    super.key,
    required this.order,
    required this.onViewDetails,
    this.onReschedule,
    this.onCancel,
    this.onReorder,
    this.onWriteReview,
    this.onRebook,
  });

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.upcoming:
        return AppTheme.warningAmber;
      case OrderStatus.completed:
        return AppTheme.successGreen;
      case OrderStatus.cancelled:
        return AppTheme.errorRed;
    }
  }

  String _getStatusText() {
    switch (order.status) {
      case OrderStatus.upcoming:
        return 'Upcoming';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    order.ritualImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.ritualName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.templeBrown,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${order.templeName}, ${order.templeLocation}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.sacredBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          order.packageType,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.sacredBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(
                      fontSize: 11,
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 14, color: AppTheme.sacredBlue),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a')
                      .format(order.scheduledDate),
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${order.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.templeBrown,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (order.status == OrderStatus.upcoming) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onViewDetails,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: const BorderSide(color: AppTheme.sacredBlue),
              ),
              child: const Text('View Details',
                  style: TextStyle(fontSize: 12, color: AppTheme.sacredBlue)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: onReschedule,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: const BorderSide(color: AppTheme.sacredBlue),
              ),
              child: const Text('Reschedule',
                  style: TextStyle(fontSize: 12, color: AppTheme.sacredBlue)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: const BorderSide(color: AppTheme.errorRed),
              ),
              child: const Text('Cancel',
                  style: TextStyle(fontSize: 12, color: AppTheme.errorRed)),
            ),
          ),
        ],
      );
    } else if (order.status == OrderStatus.completed) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onViewDetails,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: const BorderSide(color: AppTheme.sacredBlue),
              ),
              child: const Text('View Details',
                  style: TextStyle(fontSize: 12, color: AppTheme.sacredBlue)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: onReorder,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: const BorderSide(color: AppTheme.sacredBlue),
              ),
              child: const Text('Reorder',
                  style: TextStyle(fontSize: 12, color: AppTheme.sacredBlue)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: onWriteReview,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                backgroundColor: AppTheme.sacredBlue,
              ),
              child: const Text('Review',
                  style: TextStyle(fontSize: 12, color: Colors.white)),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onViewDetails,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: const BorderSide(color: AppTheme.sacredBlue),
              ),
              child: const Text('View Details',
                  style: TextStyle(fontSize: 12, color: AppTheme.sacredBlue)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: onRebook,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                backgroundColor: AppTheme.sacredBlue,
              ),
              child: const Text('Rebook',
                  style: TextStyle(fontSize: 12, color: Colors.white)),
            ),
          ),
        ],
      );
    }
  }
}
