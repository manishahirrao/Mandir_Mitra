import 'package:flutter/foundation.dart';
import '../models/ordered_ritual.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderedRitual> _orders = [];

  OrdersProvider() {
    _loadMockOrders();
  }

  List<OrderedRitual> get orders => _orders;

  List<OrderedRitual> get upcomingOrders =>
      _orders.where((o) => o.status == OrderStatus.upcoming).toList();

  List<OrderedRitual> get completedOrders =>
      _orders.where((o) => o.status == OrderStatus.completed).toList();

  List<OrderedRitual> get cancelledOrders =>
      _orders.where((o) => o.status == OrderStatus.cancelled).toList();

  OrderedRitual? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }

  void _loadMockOrders() {
    _orders = [
      OrderedRitual(
        id: 'ORD001',
        ritualId: 'R001',
        ritualName: 'Satyanarayan Puja',
        ritualImage: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1c1c1',
        templeName: 'Shri Jagannath Temple',
        templeLocation: 'Puri, Odisha',
        packageType: 'Family',
        scheduledDate: DateTime.now().add(const Duration(days: 5)),
        bookedDate: DateTime.now().subtract(const Duration(days: 2)),
        status: OrderStatus.upcoming,
        totalPrice: 5100,
        priestName: 'Pandit Ramesh Sharma',
        priestPhoto: 'https://i.pravatar.cc/150?img=12',
        liveStreamUrl: 'https://example.com/stream/ord001',
        boxStatus: AashirwadBoxStatus.prepared,
        paymentMethod: 'UPI',
        transactionId: 'TXN123456789',
      ),
      OrderedRitual(
        id: 'ORD002',
        ritualId: 'R002',
        ritualName: 'Griha Pravesh Puja',
        ritualImage: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1c1c2',
        templeName: 'Kashi Vishwanath Temple',
        templeLocation: 'Varanasi, UP',
        packageType: 'Personal',
        scheduledDate: DateTime.now().add(const Duration(days: 15)),
        bookedDate: DateTime.now().subtract(const Duration(days: 5)),
        status: OrderStatus.upcoming,
        totalPrice: 11000,
        priestName: 'Pandit Suresh Mishra',
        priestPhoto: 'https://i.pravatar.cc/150?img=13',
        liveStreamUrl: 'https://example.com/stream/ord002',
        boxStatus: AashirwadBoxStatus.prepared,
        paymentMethod: 'Credit Card',
        transactionId: 'TXN987654321',
      ),
      OrderedRitual(
        id: 'ORD003',
        ritualId: 'R003',
        ritualName: 'Lakshmi Puja',
        ritualImage: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1c1c3',
        templeName: 'Dakshineswar Temple',
        templeLocation: 'Kolkata, WB',
        packageType: 'Shared',
        scheduledDate: DateTime.now().subtract(const Duration(days: 10)),
        bookedDate: DateTime.now().subtract(const Duration(days: 20)),
        status: OrderStatus.completed,
        totalPrice: 1100,
        priestName: 'Pandit Anil Chatterjee',
        priestPhoto: 'https://i.pravatar.cc/150?img=14',
        boxStatus: AashirwadBoxStatus.delivered,
        trackingNumber: 'TRACK123456',
        expectedDeliveryDate: DateTime.now().subtract(const Duration(days: 3)),
        paymentMethod: 'UPI',
        transactionId: 'TXN456789123',
        hasReview: false,
      ),
      OrderedRitual(
        id: 'ORD004',
        ritualId: 'R004',
        ritualName: 'Rudrabhishek',
        ritualImage: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1c1c4',
        templeName: 'Mahakaleshwar Temple',
        templeLocation: 'Ujjain, MP',
        packageType: 'Family',
        scheduledDate: DateTime.now().subtract(const Duration(days: 30)),
        bookedDate: DateTime.now().subtract(const Duration(days: 40)),
        status: OrderStatus.completed,
        totalPrice: 7500,
        priestName: 'Pandit Vijay Shastri',
        priestPhoto: 'https://i.pravatar.cc/150?img=15',
        boxStatus: AashirwadBoxStatus.delivered,
        trackingNumber: 'TRACK789456',
        expectedDeliveryDate: DateTime.now().subtract(const Duration(days: 25)),
        paymentMethod: 'Debit Card',
        transactionId: 'TXN789123456',
        hasReview: true,
      ),
      OrderedRitual(
        id: 'ORD005',
        ritualId: 'R005',
        ritualName: 'Navgraha Shanti Puja',
        ritualImage: 'https://images.unsplash.com/photo-1604608672516-f1b9b1b1c1c5',
        templeName: 'Meenakshi Temple',
        templeLocation: 'Madurai, TN',
        packageType: 'Personal',
        scheduledDate: DateTime.now().subtract(const Duration(days: 7)),
        bookedDate: DateTime.now().subtract(const Duration(days: 15)),
        status: OrderStatus.cancelled,
        totalPrice: 9500,
        priestName: 'Pandit Ravi Kumar',
        priestPhoto: 'https://i.pravatar.cc/150?img=16',
        paymentMethod: 'UPI',
        transactionId: 'TXN321654987',
      ),
    ];
    notifyListeners();
  }

  Future<void> refreshOrders() async {
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = OrderedRitual(
        id: _orders[index].id,
        ritualId: _orders[index].ritualId,
        ritualName: _orders[index].ritualName,
        ritualImage: _orders[index].ritualImage,
        templeName: _orders[index].templeName,
        templeLocation: _orders[index].templeLocation,
        packageType: _orders[index].packageType,
        scheduledDate: _orders[index].scheduledDate,
        bookedDate: _orders[index].bookedDate,
        status: OrderStatus.cancelled,
        totalPrice: _orders[index].totalPrice,
        priestName: _orders[index].priestName,
        priestPhoto: _orders[index].priestPhoto,
        paymentMethod: _orders[index].paymentMethod,
        transactionId: _orders[index].transactionId,
      );
      notifyListeners();
    }
  }
}
