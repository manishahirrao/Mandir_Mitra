enum LoyaltyTier {
  bronze,
  silver,
  gold,
  platinum,
}

class LoyaltyPoints {
  final String id;
  final String userId;
  final int balance;
  final LoyaltyTier tier;
  final int earnedTotal;
  final int redeemedTotal;
  final DateTime lastActivityDate;

  LoyaltyPoints({
    required this.id,
    required this.userId,
    required this.balance,
    required this.tier,
    required this.earnedTotal,
    required this.redeemedTotal,
    required this.lastActivityDate,
  });

  LoyaltyTier calculateTier() {
    if (balance >= 3000) return LoyaltyTier.platinum;
    if (balance >= 1501) return LoyaltyTier.gold;
    if (balance >= 501) return LoyaltyTier.silver;
    return LoyaltyTier.bronze;
  }

  int pointsToNextTier() {
    switch (tier) {
      case LoyaltyTier.bronze:
        return 501 - balance;
      case LoyaltyTier.silver:
        return 1501 - balance;
      case LoyaltyTier.gold:
        return 3001 - balance;
      case LoyaltyTier.platinum:
        return 0;
    }
  }

  String getTierName() {
    switch (tier) {
      case LoyaltyTier.bronze:
        return 'Bronze';
      case LoyaltyTier.silver:
        return 'Silver';
      case LoyaltyTier.gold:
        return 'Gold';
      case LoyaltyTier.platinum:
        return 'Platinum';
    }
  }

  double getTierProgress() {
    switch (tier) {
      case LoyaltyTier.bronze:
        return balance / 500;
      case LoyaltyTier.silver:
        return (balance - 501) / 1000;
      case LoyaltyTier.gold:
        return (balance - 1501) / 1500;
      case LoyaltyTier.platinum:
        return 1.0;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'balance': balance,
      'tier': tier.toString(),
      'earnedTotal': earnedTotal,
      'redeemedTotal': redeemedTotal,
      'lastActivityDate': lastActivityDate.toIso8601String(),
    };
  }

  factory LoyaltyPoints.fromJson(Map<String, dynamic> json) {
    return LoyaltyPoints(
      id: json['id'],
      userId: json['userId'],
      balance: json['balance'],
      tier: LoyaltyTier.values.firstWhere(
        (e) => e.toString() == json['tier'],
        orElse: () => LoyaltyTier.bronze,
      ),
      earnedTotal: json['earnedTotal'],
      redeemedTotal: json['redeemedTotal'],
      lastActivityDate: DateTime.parse(json['lastActivityDate']),
    );
  }
}

enum TransactionType { earned, spent }

class PointsTransaction {
  final String id;
  final String userId;
  final int points;
  final TransactionType type;
  final String activity;
  final DateTime date;
  final String? referenceId;

  PointsTransaction({
    required this.id,
    required this.userId,
    required this.points,
    required this.type,
    required this.activity,
    required this.date,
    this.referenceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'points': points,
      'type': type.toString(),
      'activity': activity,
      'date': date.toIso8601String(),
      'referenceId': referenceId,
    };
  }

  factory PointsTransaction.fromJson(Map<String, dynamic> json) {
    return PointsTransaction(
      id: json['id'],
      userId: json['userId'],
      points: json['points'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      activity: json['activity'],
      date: DateTime.parse(json['date']),
      referenceId: json['referenceId'],
    );
  }
}

class Referral {
  final String id;
  final String referrerId;
  final String? referredUserId;
  final String code;
  final ReferralStatus status;
  final int pointsEarned;
  final DateTime date;
  final String? referredUserName;

  Referral({
    required this.id,
    required this.referrerId,
    this.referredUserId,
    required this.code,
    required this.status,
    required this.pointsEarned,
    required this.date,
    this.referredUserName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referrerId': referrerId,
      'referredUserId': referredUserId,
      'code': code,
      'status': status.toString(),
      'pointsEarned': pointsEarned,
      'date': date.toIso8601String(),
      'referredUserName': referredUserName,
    };
  }

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      id: json['id'],
      referrerId: json['referrerId'],
      referredUserId: json['referredUserId'],
      code: json['code'],
      status: ReferralStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      pointsEarned: json['pointsEarned'],
      date: DateTime.parse(json['date']),
      referredUserName: json['referredUserName'],
    );
  }
}

enum ReferralStatus {
  signedUp,
  booked,
  pointsCredited,
}

class LoyaltyReward {
  final String id;
  final String name;
  final String description;
  final int pointsRequired;
  final String icon;
  final RewardType type;
  final dynamic value;

  LoyaltyReward({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsRequired,
    required this.icon,
    required this.type,
    required this.value,
  });
}

enum RewardType {
  discount,
  upgrade,
  priority,
  extended,
  exclusive,
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int targetCount;
  final int currentCount;
  final bool isAchieved;
  final DateTime? achievedDate;
  final int pointsReward;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.targetCount,
    required this.currentCount,
    this.isAchieved = false,
    this.achievedDate,
    required this.pointsReward,
  });

  double get progress => currentCount / targetCount;
}
