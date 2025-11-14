import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/offline_action.dart';

class QueueManager extends ChangeNotifier {
  static const String _queueKey = 'offline_queue';
  List<OfflineAction> _queue = [];
  bool _isProcessing = false;

  List<OfflineAction> get queue => _queue;
  int get pendingCount => _queue.where((a) => a.status == 'pending').length;
  bool get hasQueue => _queue.isNotEmpty;
  bool get isProcessing => _isProcessing;

  Future<void> loadQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getString(_queueKey);
      
      if (queueJson != null) {
        final List<dynamic> decoded = json.decode(queueJson);
        _queue = decoded.map((item) => OfflineAction.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading queue: $e');
    }
  }

  Future<void> addToQueue(OfflineAction action) async {
    try {
      _queue.add(action);
      await _saveQueue();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding to queue: $e');
    }
  }

  Future<void> removeFromQueue(String actionId) async {
    try {
      _queue.removeWhere((action) => action.id == actionId);
      await _saveQueue();
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing from queue: $e');
    }
  }

  Future<void> updateAction(OfflineAction action) async {
    try {
      final index = _queue.indexWhere((a) => a.id == action.id);
      if (index != -1) {
        _queue[index] = action;
        await _saveQueue();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating action: $e');
    }
  }

  Future<void> clearQueue() async {
    try {
      _queue.clear();
      await _saveQueue();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing queue: $e');
    }
  }

  Future<void> clearSuccessful() async {
    try {
      _queue.removeWhere((action) => action.status == 'success');
      await _saveQueue();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing successful actions: $e');
    }
  }

  Future<void> _saveQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = json.encode(_queue.map((a) => a.toJson()).toList());
      await prefs.setString(_queueKey, queueJson);
    } catch (e) {
      debugPrint('Error saving queue: $e');
    }
  }

  List<OfflineAction> getPendingActions() {
    return _queue.where((a) => a.status == 'pending').toList();
  }

  List<OfflineAction> getFailedActions() {
    return _queue.where((a) => a.status == 'failed').toList();
  }

  void setProcessing(bool processing) {
    _isProcessing = processing;
    notifyListeners();
  }
}
