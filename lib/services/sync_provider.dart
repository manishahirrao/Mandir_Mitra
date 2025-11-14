import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/offline_action.dart';
import 'cache_manager.dart';
import 'connectivity_service.dart';
import 'queue_manager.dart';

enum SyncStatus {
  synced,
  syncing,
  pending,
  error,
}

class SyncProvider with ChangeNotifier {
  SyncStatus _syncStatus = SyncStatus.synced;
  DateTime? _lastSyncTime;
  bool _isSyncing = false;
  List<DownloadedContent> _downloads = [];
  
  final QueueManager _queueManager;
  final ConnectivityService _connectivityService;
  
  static const String _downloadsKey = 'downloaded_content';
  static const String _lastSyncKey = 'last_sync_time';

  SyncProvider(this._queueManager, this._connectivityService) {
    _loadLastSyncTime();
    _loadDownloads();
    _connectivityService.addListener(_onConnectivityChange);
  }

  void _onConnectivityChange() {
    if (_connectivityService.isOnline && _queueManager.pendingCount > 0) {
      syncAll();
    }
  }

  SyncStatus get syncStatus => _syncStatus;
  List<OfflineAction> get queuedActions => _queueManager.queue;
  DateTime? get lastSyncTime => _lastSyncTime;
  int get pendingCount => _queueManager.pendingCount;
  bool get isSyncing => _isSyncing;
  List<DownloadedContent> get downloads => _downloads;
  int get totalDownloadSize => _downloads.fold(0, (sum, d) => sum + d.fileSize);

  Future<void> _loadLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timeStr = prefs.getString(_lastSyncKey);
      if (timeStr != null) {
        _lastSyncTime = DateTime.parse(timeStr);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading last sync time: $e');
    }
  }

  Future<void> _saveLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastSyncKey, _lastSyncTime!.toIso8601String());
    } catch (e) {
      debugPrint('Error saving last sync time: $e');
    }
  }

  Future<void> _loadDownloads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadsJson = prefs.getString(_downloadsKey);
      if (downloadsJson != null) {
        final List<dynamic> decoded = json.decode(downloadsJson);
        _downloads = decoded.map((item) => DownloadedContent.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading downloads: $e');
    }
  }

  Future<void> _saveDownloads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadsJson = json.encode(_downloads.map((d) => d.toJson()).toList());
      await prefs.setString(_downloadsKey, downloadsJson);
    } catch (e) {
      debugPrint('Error saving downloads: $e');
    }
  }

  Future<void> syncAll() async {
    if (_isSyncing || _connectivityService.isOffline) return;

    _isSyncing = true;
    _syncStatus = SyncStatus.syncing;
    notifyListeners();

    try {
      _queueManager.setProcessing(true);
      
      final pendingActions = _queueManager.getPendingActions();
      
      for (final action in pendingActions) {
        try {
          await _processAction(action);
          await _queueManager.updateAction(
            action.copyWith(status: 'success'),
          );
        } catch (e) {
          debugPrint('Error processing action ${action.id}: $e');
          final retryCount = action.retryCount + 1;
          
          if (retryCount >= 3) {
            await _queueManager.updateAction(
              action.copyWith(status: 'failed', retryCount: retryCount),
            );
          } else {
            await _queueManager.updateAction(
              action.copyWith(retryCount: retryCount),
            );
          }
        }
      }

      _lastSyncTime = DateTime.now();
      await _saveLastSyncTime();
      _syncStatus = _queueManager.pendingCount == 0 ? SyncStatus.synced : SyncStatus.pending;
    } catch (e) {
      _syncStatus = SyncStatus.error;
      debugPrint('Sync error: $e');
    } finally {
      _isSyncing = false;
      _queueManager.setProcessing(false);
      notifyListeners();
    }
  }

  Future<void> _processAction(OfflineAction action) async {
    // Simulate API call with delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    switch (action.actionType) {
      case 'add_wishlist':
        debugPrint('Processing add_wishlist: ${action.payload}');
        break;
      case 'remove_wishlist':
        debugPrint('Processing remove_wishlist: ${action.payload}');
        break;
      case 'write_review':
        debugPrint('Processing write_review: ${action.payload}');
        break;
      case 'update_profile':
        debugPrint('Processing update_profile: ${action.payload}');
        break;
      case 'submit_feedback':
        debugPrint('Processing submit_feedback: ${action.payload}');
        break;
      default:
        debugPrint('Unknown action type: ${action.actionType}');
    }
  }

  Future<void> retryAction(OfflineAction action) async {
    if (_connectivityService.isOffline) {
      throw Exception('Cannot retry while offline');
    }

    try {
      await _processAction(action);
      await _queueManager.updateAction(
        action.copyWith(status: 'success'),
      );
    } catch (e) {
      final retryCount = action.retryCount + 1;
      await _queueManager.updateAction(
        action.copyWith(status: 'failed', retryCount: retryCount),
      );
      rethrow;
    }
  }

  Future<void> addDownload(DownloadedContent content) async {
    _downloads.add(content);
    await _saveDownloads();
    notifyListeners();
  }

  Future<void> deleteDownload(String id) async {
    _downloads.removeWhere((d) => d.id == id);
    await _saveDownloads();
    notifyListeners();
  }

  Future<void> clearAllDownloads() async {
    _downloads.clear();
    await _saveDownloads();
    notifyListeners();
  }

  Future<void> cleanExpiredCache() async {
    try {
      await CacheManager.cleanExpiredCache();
    } catch (e) {
      debugPrint('Error cleaning expired cache: $e');
    }
    notifyListeners();
  }

  Future<void> clearAllCache() async {
    try {
      await CacheManager.clearAllCache();
    } catch (e) {
      debugPrint('Error clearing all cache: $e');
    }
    _downloads.clear();
    await _saveDownloads();
    notifyListeners();
  }

  String getLastSyncText() {
    if (_lastSyncTime == null) return 'Never synced';
    
    final now = DateTime.now();
    final difference = now.difference(_lastSyncTime!);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  @override
  void dispose() {
    _connectivityService.removeListener(_onConnectivityChange);
    super.dispose();
  }
}
