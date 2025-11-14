import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ordered_ritual.dart';
import '../utils/app_theme.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderedRitual order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            const Divider(height: 1),
            _buildRitualInfo(),
            const Divider(height: 1),
            _buildPriestInfo(),
            const Divider(height: 1),
            _buildScheduleInfo(),
            if (order.status == OrderStatus.upcoming &&
                order.liveStreamUrl != null)
              _buildLiveStreamSection(context),
            if (order.boxStatus != null) _buildAashirwadBoxTracking(),
            const Divider(height: 1),
            _buildOrderTimeline(),
            const Divider(height: 1),
            _buildPaymentDetails(),
            const SizedBox(height: 16),
            _buildActionButtons(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.sacredBlue.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID: ${order.id}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.templeBrown,
                ),
              ),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Booked on ${DateFormat('dd MMM yyyy').format(order.bookedDate)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;
    switch (order.status) {
      case OrderStatus.upcoming:
        color = AppTheme.warningAmber;
        text = 'Upcoming';
        break;
      case OrderStatus.completed:
        color = AppTheme.successGreen;
        text = 'Completed';
        break;
      case OrderStatus.cancelled:
        color = AppTheme.errorRed;
        text = 'Cancelled';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRitualInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ritual Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  order.ritualImage,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.ritualName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${order.templeName}\n${order.templeLocation}',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.sacredBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${order.packageType} Package',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.sacredBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriestInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Priest Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(order.priestPhoto),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.priestName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Certified Priest',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today,
                  size: 20, color: AppTheme.sacredBlue),
              const SizedBox(width: 12),
              Text(
                DateFormat('EEEE, dd MMMM yyyy').format(order.scheduledDate),
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time,
                  size: 20, color: AppTheme.sacredBlue),
              const SizedBox(width: 12),
              Text(
                DateFormat('hh:mm a').format(order.scheduledDate),
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveStreamSection(BuildContext context) {
    final now = DateTime.now();
    final isLive = now.isAfter(order.scheduledDate) &&
        now.isBefore(order.scheduledDate.add(const Duration(hours: 2)));

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.sacredBlue, AppTheme.sacredBlue.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (isLive)
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              if (isLive) const SizedBox(width: 8),
              Text(
                isLive ? 'LIVE NOW' : 'Live Stream Available',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening live stream...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.sacredBlue,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_filled),
                SizedBox(width: 8),
                Text('Join Live Stream', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAashirwadBoxTracking() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aashirwad Box Tracking',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.sacredBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.sacredBlue.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildBoxStatusBadge(),
                  ],
                ),
                if (order.trackingNumber != null) ...[
                  const SizedBox(height: 8),
                  Text('Tracking: ${order.trackingNumber}'),
                ],
                if (order.expectedDeliveryDate != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Expected Delivery: ${DateFormat('dd MMM yyyy').format(order.expectedDeliveryDate!)}',
                  ),
                ],
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.sacredBlue),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('Track Order',
                      style: TextStyle(color: AppTheme.sacredBlue)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxStatusBadge() {
    Color color;
    String text;
    switch (order.boxStatus) {
      case AashirwadBoxStatus.prepared:
        color = AppTheme.warningAmber;
        text = 'Prepared';
        break;
      case AashirwadBoxStatus.shipped:
        color = AppTheme.sacredBlue;
        text = 'Shipped';
        break;
      case AashirwadBoxStatus.delivered:
        color = AppTheme.successGreen;
        text = 'Delivered';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildOrderTimeline() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 16),
          _buildTimelineItem('Booked', order.bookedDate, true),
          _buildTimelineItem('Confirmed', order.bookedDate, true),
          if (order.status == OrderStatus.completed)
            _buildTimelineItem('Ritual Performed', order.scheduledDate, true),
          if (order.boxStatus == AashirwadBoxStatus.shipped ||
              order.boxStatus == AashirwadBoxStatus.delivered)
            _buildTimelineItem('Box Shipped',
                order.scheduledDate.add(const Duration(days: 1)), true),
          if (order.boxStatus == AashirwadBoxStatus.delivered)
            _buildTimelineItem('Delivered', order.expectedDeliveryDate!, true),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, DateTime date, bool isCompleted) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted ? AppTheme.successGreen : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            if (title != 'Delivered')
              Container(
                width: 2,
                height: 30,
                color: isCompleted ? AppTheme.successGreen : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.black : Colors.grey,
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy, hh:mm a').format(date),
                style: TextStyle(
                  fontSize: 13,
                  color: isCompleted ? Colors.grey : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.templeBrown,
            ),
          ),
          const SizedBox(height: 12),
          _buildPaymentRow('Amount Paid', '₹${order.totalPrice.toStringAsFixed(0)}'),
          _buildPaymentRow('Payment Method', order.paymentMethod),
          _buildPaymentRow('Transaction ID', order.transactionId),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading invoice...')),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Download Invoice'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.sacredBlue),
              foregroundColor: AppTheme.sacredBlue,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening support...')),
              );
            },
            icon: const Icon(Icons.support_agent),
            label: const Text('Contact Support'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.sacredBlue),
              foregroundColor: AppTheme.sacredBlue,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}
