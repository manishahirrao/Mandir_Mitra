class WishlistItem {
  final String id;
  final String userId;
  final String ritualId;
  final DateTime addedAt;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.ritualId,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'ritualId': ritualId,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
      userId: json['userId'],
      ritualId: json['ritualId'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }
}
