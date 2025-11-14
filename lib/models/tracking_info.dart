enum TrackingStatus {
  preparing,
  packed,
  shipped,
  inTransit,
  outForDelivery,
  delivered,
  exception,
}

enum IssueType {
  notReceived,
  damaged,
  missingItems,
  lateDelivery,
  other,
}

enum TimeSlot {
  morning,
  afternoon,
  evening,
}

class TrackingInfo {
  final String id;
  final String orderId;
  final TrackingStatus status;
  final String? courierName;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;
  final String? currentLocation;
  final List<TrackingUpdate> updates;
  final DeliveryProof? deliveryProof;
  final List<BoxItem> boxContents;
  final String deliveryAddress;
  final String? specialInstructions;
  final int rescheduleCount;

  TrackingInfo({
    required this.id,
    required this.orderId,
    required this.status,
    this.courierName,
    this.trackingNumber,
    this.estimatedDelivery,
    this.currentLocation,
    required this.updates,
    this.deliveryProof,
    required this.boxContents,
    required this.deliveryAddress,
    this.specialInstructions,
    this.rescheduleCount = 0,
  });

  String getStatusText() {
    switch (status) {
      case TrackingStatus.preparing:
        return 'Preparing';
      case TrackingStatus.packed:
        return 'Packed';
      case TrackingStatus.shipped:
        return 'Shipped';
      case TrackingStatus.inTransit:
        return 'In Transit';
      case TrackingStatus.outForDelivery:
        return 'Out for Delivery';
      case TrackingStatus.delivered:
        return 'Delivered';
      case TrackingStatus.exception:
        return 'Exception';
    }
  }

  bool get canReschedule =>
      rescheduleCount < 2 &&
      (status == TrackingStatus.shipped || status == TrackingStatus.inTransit);

  bool get isDelivered => status == TrackingStatus.delivered;
  bool get isOutForDelivery => status == TrackingStatus.outForDelivery;
}

class TrackingUpdate {
  final DateTime timestamp;
  final TrackingStatus status;
  final String location;
  final String remarks;
  final String? photoUrl;

  TrackingUpdate({
    required this.timestamp,
    required this.status,
    required this.location,
    required this.remarks,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString(),
      'location': location,
      'remarks': remarks,
      'photoUrl': photoUrl,
    };
  }

  factory TrackingUpdate.fromJson(Map<String, dynamic> json) {
    return TrackingUpdate(
      timestamp: DateTime.parse(json['timestamp']),
      status: TrackingStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      location: json['location'],
      remarks: json['remarks'],
      photoUrl: json['photoUrl'],
    );
  }
}

class DeliveryProof {
  final String photoUrl;
  final String? signature;
  final String deliveredTo;
  final DateTime deliveryTime;

  DeliveryProof({
    required this.photoUrl,
    this.signature,
    required this.deliveredTo,
    required this.deliveryTime,
  });
}

class BoxItem {
  final String name;
  final String icon;
  final String description;
  final bool isVerified;

  BoxItem({
    required this.name,
    required this.icon,
    required this.description,
    this.isVerified = false,
  });

  static List<BoxItem> get defaultItems => [
        BoxItem(
          name: 'Holy Water (Gangajal)',
          icon: '💧',
          description: '100ml bottle',
        ),
        BoxItem(
          name: 'Sacred Thread (Moli)',
          icon: '🧵',
          description: 'Red, blessed',
        ),
        BoxItem(
          name: 'Kumkum',
          icon: '🔴',
          description: 'Small container',
        ),
        BoxItem(
          name: 'Prasad',
          icon: '🍯',
          description: 'Sweets from ritual',
        ),
        BoxItem(
          name: 'Incense Sticks',
          icon: '🕯️',
          description: '10 pieces',
        ),
        BoxItem(
          name: 'Sacred Ash (Vibhuti)',
          icon: '⚪',
          description: 'Blessed ash',
        ),
        BoxItem(
          name: 'Deity Photo',
          icon: '🖼️',
          description: 'Small photo',
        ),
        BoxItem(
          name: 'Blessing Card',
          icon: '💌',
          description: 'Personalized message',
        ),
      ];
}

class DeliveryIssue {
  final String id;
  final String orderId;
  final IssueType issueType;
  final String description;
  final List<String> photos;
  final String status;
  final String ticketId;
  final DateTime createdAt;

  DeliveryIssue({
    required this.id,
    required this.orderId,
    required this.issueType,
    required this.description,
    required this.photos,
    required this.status,
    required this.ticketId,
    required this.createdAt,
  });

  String getIssueTypeText() {
    switch (issueType) {
      case IssueType.notReceived:
        return 'Box not received';
      case IssueType.damaged:
        return 'Damaged items';
      case IssueType.missingItems:
        return 'Missing items';
      case IssueType.lateDelivery:
        return 'Late delivery';
      case IssueType.other:
        return 'Other';
    }
  }
}

class DeliveryFeedback {
  final String orderId;
  final bool onTime;
  final bool packagingIntact;
  final double rating;
  final Map<String, bool> itemsIncluded;
  final String? comments;

  DeliveryFeedback({
    required this.orderId,
    required this.onTime,
    required this.packagingIntact,
    required this.rating,
    required this.itemsIncluded,
    this.comments,
  });
}
