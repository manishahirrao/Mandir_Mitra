import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/tracking_info.dart';

class TrackingProvider with ChangeNotifier {
  final Map<String, TrackingInfo> _trackingData = {};
  Timer? _statusUpdateTimer;

  TrackingProvider() {
    _initializeMockData();
    _startStatusUpdates();
  }

  TrackingInfo? getTrackingInfo(String orderId) {
    return _trackingData[orderId];
  }

  List<TrackingInfo> getAllTracking() {
    return _trackingData.values.toList();
  }

  List<TrackingInfo> getInTransitBoxes() {
    return _trackingData.values
        .where((t) =>
            t.status != TrackingStatus.delivered &&
            t.status != TrackingStatus.exception)
        .toList();
  }

  int get inTransitCount => getInTransitBoxes().length;

  Future<void> updateTrackingStatus(String orderId, TrackingStatus newStatus) async {
    final tracking = _trackingData[orderId];
    if (tracking == null) return;

    final newUpdate = TrackingUpdate(
      timestamp: DateTime.now(),
      status: newStatus,
      location: _getLocationForStatus(newStatus),
      remarks: _getRemarksForStatus(newStatus),
    );

    final updatedTracking = TrackingInfo(
      id: tracking.id,
      orderId: tracking.orderId,
      status: newStatus,
      courierName: tracking.courierName,
      trackingNumber: tracking.trackingNumber,
      estimatedDelivery: tracking.estimatedDelivery,
      currentLocation: newUpdate.location,
      updates: [...tracking.updates, newUpdate],
      deliveryProof: tracking.deliveryProof,
      boxContents: tracking.boxContents,
      deliveryAddress: tracking.deliveryAddress,
      specialInstructions: tracking.specialInstructions,
      rescheduleCount: tracking.rescheduleCount,
    );

    _trackingData[orderId] = updatedTracking;
    notifyListeners();
  }

  Future<String> reportIssue(DeliveryIssue issue) async {
    await Future.delayed(const Duration(seconds: 1));
    // In production, send to backend
    return issue.ticketId;
  }

  Future<bool> rescheduleDelivery(
    String orderId,
    DateTime newDate,
    TimeSlot timeSlot,
  ) async {
    final tracking = _trackingData[orderId];
    if (tracking == null || !tracking.canReschedule) return false;

    await Future.delayed(const Duration(seconds: 1));

    final updatedTracking = TrackingInfo(
      id: tracking.id,
      orderId: tracking.orderId,
      status: tracking.status,
      courierName: tracking.courierName,
      trackingNumber: tracking.trackingNumber,
      estimatedDelivery: newDate,
      currentLocation: tracking.currentLocation,
      updates: tracking.updates,
      deliveryProof: tracking.deliveryProof,
      boxContents: tracking.boxContents,
      deliveryAddress: tracking.deliveryAddress,
      specialInstructions: tracking.specialInstructions,
      rescheduleCount: tracking.rescheduleCount + 1,
    );

    _trackingData[orderId] = updatedTracking;
    notifyListeners();
    return true;
  }

  Future<void> submitDeliveryFeedback(DeliveryFeedback feedback) async {
    await Future.delayed(const Duration(seconds: 1));
    // In production, send to backend
    notifyListeners();
  }

  Future<void> updateSpecialInstructions(String orderId, String instructions) async {
    final tracking = _trackingData[orderId];
    if (tracking == null) return;

    final updatedTracking = TrackingInfo(
      id: tracking.id,
      orderId: tracking.orderId,
      status: tracking.status,
      courierName: tracking.courierName,
      trackingNumber: tracking.trackingNumber,
      estimatedDelivery: tracking.estimatedDelivery,
      currentLocation: tracking.currentLocation,
      updates: tracking.updates,
      deliveryProof: tracking.deliveryProof,
      boxContents: tracking.boxContents,
      deliveryAddress: tracking.deliveryAddress,
      specialInstructions: instructions,
      rescheduleCount: tracking.rescheduleCount,
    );

    _trackingData[orderId] = updatedTracking;
    notifyListeners();
  }

  void _initializeMockData() {
    // Mock tracking for order 1 - In Transit
    _trackingData['ORD001'] = TrackingInfo(
      id: 'TRACK001',
      orderId: 'ORD001',
      status: TrackingStatus.inTransit,
      courierName: 'Blue Dart',
      trackingNumber: 'BD123456789IN',
      estimatedDelivery: DateTime.now().add(const Duration(days: 2)),
      currentLocation: 'Mumbai Sorting Facility',
      updates: [
        TrackingUpdate(
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          status: TrackingStatus.preparing,
          location: 'Puri Temple',
          remarks: 'Your ritual has been completed',
        ),
        TrackingUpdate(
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          status: TrackingStatus.packed,
          location: 'Puri Temple',
          remarks: 'Sacred items blessed and packed',
        ),
        TrackingUpdate(
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          status: TrackingStatus.shipped,
          location: 'Puri',
          remarks: 'Package handed over to courier',
        ),
        TrackingUpdate(
          timestamp: DateTime.now().subtract(const Duration(hours: 12)),
          status: TrackingStatus.inTransit,
          location: 'Mumbai Sorting Facility',
          remarks: 'Package is on the way to you',
        ),
      ],
      boxContents: BoxItem.defaultItems,
      deliveryAddress: '123, MG Road, Koramangala, Bangalore - 560034',
      specialInstructions: 'Ring bell on arrival',
    );

    // Mock tracking for order 2 - Delivered
    _trackingData['ORD003'] = TrackingInfo(
      id: 'TRACK003',
      orderId: 'ORD003',
      status: TrackingStatus.delivered,
      courierName: 'DTDC',
      trackingNumber: 'DTDC987654321IN',
      estimatedDelivery: DateTime.now().subtract(const Duration(days: 3)),
      currentLocation: 'Delivered',
      updates: [
        TrackingUpdate(
          timestamp: DateTime.now().subtract(const Duration(days: 15)),
          status: TrackingStatus.preparing,
          location: 'Dakshineswar Temple',
          remarks: 'Your ritual has been completed',
        ),
        TrackingUpdate(
          timestamp: DateTime.now().subtract(const Duration(days: 14)),
          status: TrackingStatus.packed,
          location: 'Dakshineswar Temple',
          remarks: 'Sacred items blessed and packed',
        ),
        TrackingUpdate(
          timestamp: DateTime.now().subtract(const Duration(days: 13)),
          status: TrackingStatus.shipped,
          location: 'Kolkata',
          remarks: 'Package handed over to courier',
        ),
        TrackingUpdate(
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          status: TrackingStatus.inTransit,
          location: 'Bangalore Hub',
          remarks: 'Package arrived at destination city',
        ),
        TrackingUpdate(
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          status: TrackingStatus.outForDelivery,
          location: 'Bangalore',
          remarks: 'Out for delivery',
        ),
        TrackingUpdate(
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          status: TrackingStatus.delivered,
          location: 'Bangalore',
          remarks: 'Delivered successfully',
        ),
      ],
      deliveryProof: DeliveryProof(
        photoUrl: 'https://via.placeholder.com/300x200',
        deliveredTo: 'Rajesh Kumar',
        deliveryTime: DateTime.now().subtract(const Duration(days: 3)),
      ),
      boxContents: BoxItem.defaultItems,
      deliveryAddress: '123, MG Road, Koramangala, Bangalore - 560034',
    );
  }

  void _startStatusUpdates() {
    // Simulate status progression for demo
    _statusUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // Update mock data status progression
      _trackingData.forEach((orderId, tracking) {
        if (tracking.status == TrackingStatus.inTransit) {
          // Randomly update location
          final locations = [
            'Mumbai Sorting Facility',
            'Pune Hub',
            'Bangalore Hub',
            'Local Delivery Center',
          ];
          final randomLocation = locations[DateTime.now().second % locations.length];
          
          if (tracking.currentLocation != randomLocation) {
            final updatedTracking = TrackingInfo(
              id: tracking.id,
              orderId: tracking.orderId,
              status: tracking.status,
              courierName: tracking.courierName,
              trackingNumber: tracking.trackingNumber,
              estimatedDelivery: tracking.estimatedDelivery,
              currentLocation: randomLocation,
              updates: tracking.updates,
              deliveryProof: tracking.deliveryProof,
              boxContents: tracking.boxContents,
              deliveryAddress: tracking.deliveryAddress,
              specialInstructions: tracking.specialInstructions,
              rescheduleCount: tracking.rescheduleCount,
            );
            _trackingData[orderId] = updatedTracking;
          }
        }
      });
      notifyListeners();
    });
  }

  String _getLocationForStatus(TrackingStatus status) {
    switch (status) {
      case TrackingStatus.preparing:
        return 'Temple';
      case TrackingStatus.packed:
        return 'Temple';
      case TrackingStatus.shipped:
        return 'Origin City';
      case TrackingStatus.inTransit:
        return 'In Transit';
      case TrackingStatus.outForDelivery:
        return 'Your City';
      case TrackingStatus.delivered:
        return 'Delivered';
      case TrackingStatus.exception:
        return 'Exception';
    }
  }

  String _getRemarksForStatus(TrackingStatus status) {
    switch (status) {
      case TrackingStatus.preparing:
        return 'Your ritual has been completed';
      case TrackingStatus.packed:
        return 'Sacred items blessed and packed';
      case TrackingStatus.shipped:
        return 'Package handed over to courier';
      case TrackingStatus.inTransit:
        return 'Package is on the way to you';
      case TrackingStatus.outForDelivery:
        return 'Out for delivery';
      case TrackingStatus.delivered:
        return 'Delivered successfully';
      case TrackingStatus.exception:
        return 'Delivery exception occurred';
    }
  }

  @override
  void dispose() {
    _statusUpdateTimer?.cancel();
    super.dispose();
  }
}
