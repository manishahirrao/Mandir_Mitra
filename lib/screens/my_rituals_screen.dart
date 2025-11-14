import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/orders_provider.dart';
import '../models/ordered_ritual.dart';
import '../widgets/my_rituals/ritual_order_card.dart';
import '../utils/app_theme.dart';
import 'order_detail_screen.dart';

class MyRitualsScreen extends StatefulWidget {
  const MyRitualsScreen({super.key});

  @override
  State<MyRitualsScreen> createState() => _MyRitualsScreenState();
}

class _MyRitualsScreenState extends State<MyRitualsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'date';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rituals'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'date', child: Text('Sort by Date')),
              const PopupMenuItem(value: 'price', child: Text('Sort by Price')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: Consumer<OrdersProvider>(
        builder: (context, ordersProvider, child) {
          return RefreshIndicator(
            onRefresh: ordersProvider.refreshOrders,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(ordersProvider.upcomingOrders),
                _buildOrdersList(ordersProvider.completedOrders),
                _buildOrdersList(ordersProvider.cancelledOrders),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(List<OrderedRitual> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    final sortedOrders = List<OrderedRitual>.from(orders);
    if (_sortBy == 'date') {
      sortedOrders.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
    } else if (_sortBy == 'price') {
      sortedOrders.sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sortedOrders.length,
      itemBuilder: (context, index) {
        final order = sortedOrders[index];
        return RitualOrderCard(
          order: order,
          onViewDetails: () => _navigateToOrderDetail(order),
          onReschedule: order.status == OrderStatus.upcoming
              ? () => _showRescheduleDialog(order)
              : null,
          onCancel: order.status == OrderStatus.upcoming
              ? () => _showCancelDialog(order)
              : null,
          onReorder: order.status == OrderStatus.completed
              ? () => _reorderRitual(order)
              : null,
          onWriteReview: order.status == OrderStatus.completed
              ? () => _showReviewDialog(order)
              : null,
          onRebook: order.status == OrderStatus.cancelled
              ? () => _reorderRitual(order)
              : null,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No rituals found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Book your first ritual to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.sacredBlue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Explore Rituals',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToOrderDetail(OrderedRitual order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(order: order),
      ),
    );
  }

  void _showRescheduleDialog(OrderedRitual order) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Reschedule Ritual',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Select new date and time for your ritual'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reschedule feature coming soon')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sacredBlue,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Select Date & Time',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(OrderedRitual order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Ritual'),
        content: const Text(
            'Are you sure you want to cancel this ritual booking? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<OrdersProvider>(context, listen: false)
                  .cancelOrder(order.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ritual booking cancelled')),
              );
            },
            child: const Text('Yes, Cancel',
                style: TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
  }

  void _reorderRitual(OrderedRitual order) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Redirecting to ritual booking...')),
    );
  }

  void _showReviewDialog(OrderedRitual order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Write a Review',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Rate your experience'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: const Icon(Icons.star_border, size: 32),
                    onPressed: () {},
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Review submitted successfully')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sacredBlue,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Submit Review',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
