import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../models/loyalty_points.dart';

class LoyaltyProvider with ChangeNotifier {
  LoyaltyPoints? _loyaltyPoints;
  List<PointsTransaction> _transactions = [];
  List<Referral> _referrals = [];
  List<Achievement> _achievements = [];
  String? _referralCode;
  bool _isLoading = false;

  LoyaltyProvider() {
    _initializeLoyalty();
  }

  LoyaltyPoints? get loyaltyPoints => _loyaltyPoints;
  List<PointsTransaction> get transactions => _transactions;
  List<Referral> get referrals => _referrals;
  List<Achievement> get achievements => _achievements;
  String? get referralCode => _referralCode;
  bool get isLoading => _isLoading;

  int get pointsBalance => _loyaltyPoints?.balance ?? 0;
  LoyaltyTier get currentTier => _loyaltyPoints?.tier ?? LoyaltyTier.bronze;

  Future<void> _initializeLoyalty() async {
    _isLoading = true;
    notifyListeners();

    await _loadLoyaltyData();
    _generateReferralCode();
    _initializeAchievements();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadLoyaltyData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load loyalty points
      final pointsJson = prefs.getString('loyalty_points');
      if (pointsJson != null) {
        _loyaltyPoints = LoyaltyPoints.fromJson(json.decode(pointsJson));
      } else {
        _loyaltyPoints = LoyaltyPoints(
          id: 'LP001',
          userId: 'USER001',
          balance: 250,
          tier: LoyaltyTier.bronze,
          earnedTotal: 250,
          redeemedTotal: 0,
          lastActivityDate: DateTime.now(),
        );
      }

      // Load transactions
      final transactionsJson = prefs.getString('points_transactions');
      if (transactionsJson != null) {
        final List<dynamic> decoded = json.decode(transactionsJson);
        _transactions = decoded.map((t) => PointsTransaction.fromJson(t)).toList();
      } else {
        _generateMockTransactions();
      }

      // Load referrals
      final referralsJson = prefs.getString('referrals');
      if (referralsJson != null) {
        final List<dynamic> decoded = json.decode(referralsJson);
        _referrals = decoded.map((r) => Referral.fromJson(r)).toList();
      }
    } catch (e) {
      debugPrint('Error loading loyalty data: $e');
    }
  }

  Future<void> _saveLoyaltyData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_loyaltyPoints != null) {
        await prefs.setString(
          'loyalty_points',
          json.encode(_loyaltyPoints!.toJson()),
        );
      }

      await prefs.setString(
        'points_transactions',
        json.encode(_transactions.map((t) => t.toJson()).toList()),
      );

      await prefs.setString(
        'referrals',
        json.encode(_referrals.map((r) => r.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error saving loyalty data: $e');
    }
  }

  void _generateReferralCode() {
    _referralCode = 'MANDIR${Random().nextInt(999999).toString().padLeft(6, '0')}';
  }

  Future<void> addPoints(String activity, int points, {String? referenceId}) async {
    if (_loyaltyPoints == null) return;

    final transaction = PointsTransaction(
      id: 'TXN${DateTime.now().millisecondsSinceEpoch}',
      userId: _loyaltyPoints!.userId,
      points: points,
      type: TransactionType.earned,
      activity: activity,
      date: DateTime.now(),
      referenceId: referenceId,
    );

    _transactions.insert(0, transaction);

    _loyaltyPoints = LoyaltyPoints(
      id: _loyaltyPoints!.id,
      userId: _loyaltyPoints!.userId,
      balance: _loyaltyPoints!.balance + points,
      tier: _calculateTier(_loyaltyPoints!.balance + points),
      earnedTotal: _loyaltyPoints!.earnedTotal + points,
      redeemedTotal: _loyaltyPoints!.redeemedTotal,
      lastActivityDate: DateTime.now(),
    );

    await _saveLoyaltyData();
    notifyListeners();
  }

  Future<bool> redeemPoints(String rewardId, int points) async {
    if (_loyaltyPoints == null || _loyaltyPoints!.balance < points) {
      return false;
    }

    final transaction = PointsTransaction(
      id: 'TXN${DateTime.now().millisecondsSinceEpoch}',
      userId: _loyaltyPoints!.userId,
      points: points,
      type: TransactionType.spent,
      activity: 'Redeemed reward',
      date: DateTime.now(),
      referenceId: rewardId,
    );

    _transactions.insert(0, transaction);

    _loyaltyPoints = LoyaltyPoints(
      id: _loyaltyPoints!.id,
      userId: _loyaltyPoints!.userId,
      balance: _loyaltyPoints!.balance - points,
      tier: _calculateTier(_loyaltyPoints!.balance - points),
      earnedTotal: _loyaltyPoints!.earnedTotal,
      redeemedTotal: _loyaltyPoints!.redeemedTotal + points,
      lastActivityDate: DateTime.now(),
    );

    await _saveLoyaltyData();
    notifyListeners();
    return true;
  }

  LoyaltyTier _calculateTier(int balance) {
    if (balance >= 3000) return LoyaltyTier.platinum;
    if (balance >= 1501) return LoyaltyTier.gold;
    if (balance >= 501) return LoyaltyTier.silver;
    return LoyaltyTier.bronze;
  }

  List<PointsTransaction> getFilteredTransactions(TransactionType? filter) {
    if (filter == null) return _transactions;
    return _transactions.where((t) => t.type == filter).toList();
  }

  Future<bool> validateReferralCode(String code) async {
    await Future.delayed(const Duration(seconds: 1));
    return code.startsWith('MANDIR') && code.length == 12;
  }

  Future<void> applyReferralCode(String code) async {
    // In production, this would register the referral on backend
    await Future.delayed(const Duration(seconds: 1));
  }

  int getReferralCount() => _referrals.length;
  
  int getTotalReferralPoints() {
    return _referrals.fold(0, (sum, r) => sum + r.pointsEarned);
  }

  int getSuccessfulReferrals() {
    return _referrals.where((r) => r.status == ReferralStatus.pointsCredited).length;
  }

  List<LoyaltyReward> getAvailableRewards() {
    return [
      LoyaltyReward(
        id: 'R001',
        name: '₹100 OFF',
        description: '₹100 off on next booking',
        pointsRequired: 500,
        icon: '💰',
        type: RewardType.discount,
        value: 100,
      ),
      LoyaltyReward(
        id: 'R002',
        name: 'Free Upgrade',
        description: 'Free Aashirwad Box upgrade',
        pointsRequired: 300,
        icon: '📦',
        type: RewardType.upgrade,
        value: 'aashirwad_box',
      ),
      LoyaltyReward(
        id: 'R003',
        name: 'Priority Booking',
        description: 'Priority priest booking',
        pointsRequired: 200,
        icon: '⭐',
        type: RewardType.priority,
        value: 'priest_booking',
      ),
      LoyaltyReward(
        id: 'R004',
        name: 'Extended Recording',
        description: 'Extended live stream recording',
        pointsRequired: 150,
        icon: '📹',
        type: RewardType.extended,
        value: 'stream_recording',
      ),
      LoyaltyReward(
        id: 'R005',
        name: 'Exclusive Offerings',
        description: 'Exclusive deity offerings',
        pointsRequired: 400,
        icon: '🙏',
        type: RewardType.exclusive,
        value: 'deity_offerings',
      ),
    ];
  }

  void _initializeAchievements() {
    _achievements = [
      Achievement(
        id: 'ACH001',
        name: 'First Timer',
        description: 'Complete your first ritual',
        icon: '🎯',
        targetCount: 1,
        currentCount: 0,
        pointsReward: 50,
      ),
      Achievement(
        id: 'ACH002',
        name: 'Social Butterfly',
        description: 'Share 5 rituals',
        icon: '🦋',
        targetCount: 5,
        currentCount: 0,
        pointsReward: 100,
      ),
      Achievement(
        id: 'ACH003',
        name: 'Devoted',
        description: 'Book 10 rituals',
        icon: '🙏',
        targetCount: 10,
        currentCount: 0,
        pointsReward: 200,
      ),
      Achievement(
        id: 'ACH004',
        name: 'Reviewer',
        description: 'Write 5 reviews',
        icon: '⭐',
        targetCount: 5,
        currentCount: 0,
        pointsReward: 150,
      ),
      Achievement(
        id: 'ACH005',
        name: 'Referral Champion',
        description: 'Refer 10 friends',
        icon: '👥',
        targetCount: 10,
        currentCount: 0,
        pointsReward: 500,
      ),
      Achievement(
        id: 'ACH006',
        name: 'Streak Keeper',
        description: 'Daily app open for 7 days',
        icon: '🔥',
        targetCount: 7,
        currentCount: 0,
        pointsReward: 100,
      ),
    ];
  }

  void _generateMockTransactions() {
    _transactions = [
      PointsTransaction(
        id: 'TXN001',
        userId: 'USER001',
        points: 100,
        type: TransactionType.earned,
        activity: 'First ritual completed',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      PointsTransaction(
        id: 'TXN002',
        userId: 'USER001',
        points: 50,
        type: TransactionType.earned,
        activity: 'Ritual booking',
        date: DateTime.now().subtract(const Duration(days: 10)),
      ),
      PointsTransaction(
        id: 'TXN003',
        userId: 'USER001',
        points: 20,
        type: TransactionType.earned,
        activity: 'Review submitted',
        date: DateTime.now().subtract(const Duration(days: 12)),
      ),
      PointsTransaction(
        id: 'TXN004',
        userId: 'USER001',
        points: 50,
        type: TransactionType.earned,
        activity: 'Profile completed',
        date: DateTime.now().subtract(const Duration(days: 15)),
      ),
      PointsTransaction(
        id: 'TXN005',
        userId: 'USER001',
        points: 30,
        type: TransactionType.earned,
        activity: 'Review with photos',
        date: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
  }
}
