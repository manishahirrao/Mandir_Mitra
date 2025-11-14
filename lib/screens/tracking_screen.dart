import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/tracking_provider.dart';
import '../models/tracking_info.dart';
import '../utils/app_theme.dart';
import 'report_delivery_issue_screen.dart';

class TrackingScreen extends StatelessWidget {
  final String orderId;

  const TrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Aashirwad Box'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<TrackingProvider>(
        builder: (context, provider, child) {
          final tracking = provider.getTrackingInfo(orderId);

          if (tracking == null) {
            return const Center(
              child: Text('Tracking information not available'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrackingHeader(context, tracking),
                const Divider(height: 1),
                _buildTrackingTimeline(tracking),
                const Divider(height: 1),
                _buildBoxContents(tracking),
                const Divider(height: 1),
                _buildDeliveryInstructions(context, tracking),
                if (tracking.deliveryProof != null) ...[
                  const Divider(height: 1),
                  _buildDeliveryProof(tracking.deliveryProof!),
                ],
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrackingHeader(BuildContext context, TrackingInfo tracking) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: _getStatusColor(tracking.status).withOpacity(0.1),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/80'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${tracking.orderId}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (tracking.estimatedDelivery != null)
                      Text(
                        'Expected by ${DateFormat('dd MMM yyyy').format(tracking.estimatedDelivery!)}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _getStatusColor(tracking.status),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getStatusIcon(tracking.status),
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  tracking.getStatusText(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (tracking.trackingNumber != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tracking Number',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          tracking.trackingNumber!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 16),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: tracking.trackingNumber!),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                if (tracking.courierName != null)
                  TextButton(
                    onPressed: () => _launchCourierWebsite(tracking.trackingNumber!),
                    child: const Text('Track on courier website'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(TrackingInfo tracking) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tracking Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 16),
          ...tracking.updates.asMap().entries.map((entry) {
            final index = entry.key;
            final update = entry.value;
            final isLast = index == tracking.updates.length - 1;
            final isCurrent = update.status == tracking.status;

            return _buildTimelineItem(
              update,
              isLast: isLast,
              isCurrent: isCurrent,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    TrackingUpdate update, {
    required bool isLast,
    required bool isCurrent,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppTheme.sacredBlue
                    : AppTheme.successGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCurrent ? Icons.circle : Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                update.remarks,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${update.location} • ${DateFormat('dd MMM, hh:mm a').format(update.timestamp)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBoxContents(TrackingInfo tracking) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What\'s Inside Your Box',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 16),
          ...tracking.boxContents.map((item) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Text(
                    item.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: tracking.isDelivered
                      ? Checkbox(
                          value: item.isVerified,
                          onChanged: (value) {},
                        )
                      : null,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDeliveryInstructions(BuildContext context, TrackingInfo tracking) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Instructions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tracking.deliveryAddress,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  if (tracking.specialInstructions != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tracking.specialInstructions!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (tracking.canReschedule)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _showRescheduleDialog(context, tracking),
                            child: const Text('Reschedule'),
                          ),
                        ),
                      if (tracking.canReschedule) const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReportDeliveryIssueScreen(orderId: tracking.orderId),
                              ),
                            );
                          },
                          child: const Text('Report Issue'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryProof(DeliveryProof proof) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Proof',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      proof.photoUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Delivered to: ${proof.deliveredTo}'),
                  Text(
                    'Delivered on: ${DateFormat('dd MMM yyyy, hh:mm a').format(proof.deliveryTime)}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TrackingStatus status) {
    switch (status) {
      case TrackingStatus.preparing:
        return AppTheme.warningAmber;
      case TrackingStatus.packed:
        return Colors.blue;
      case TrackingStatus.shipped:
      case TrackingStatus.inTransit:
        return AppTheme.sacredBlue;
      case TrackingStatus.outForDelivery:
        return Colors.green;
      case TrackingStatus.delivered:
        return AppTheme.successGreen;
      case TrackingStatus.exception:
        return AppTheme.errorRed;
    }
  }

  IconData _getStatusIcon(TrackingStatus status) {
    switch (status) {
      case TrackingStatus.preparing:
        return Icons.inventory_2;
      case TrackingStatus.packed:
        return Icons.check_box;
      case TrackingStatus.shipped:
        return Icons.local_shipping;
      case TrackingStatus.inTransit:
        return Icons.flight;
      case TrackingStatus.outForDelivery:
        return Icons.delivery_dining;
      case TrackingStatus.delivered:
        return Icons.check_circle;
      case TrackingStatus.exception:
        return Icons.error;
    }
  }

  void _launchCourierWebsite(String trackingNumber) async {
    final url = Uri.parse('https://www.bluedart.com/tracking?id=$trackingNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showRescheduleDialog(BuildContext context, TrackingInfo tracking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reschedule Delivery'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reschedules remaining: ${2 - tracking.rescheduleCount}'),
            const SizedBox(height: 16),
            const Text('Select new delivery date and time slot'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delivery rescheduled successfully')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
