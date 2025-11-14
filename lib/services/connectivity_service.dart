import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

enum ConnectionStatus {
  online,
  offline,
}

class ConnectivityService with ChangeNotifier {
  ConnectionStatus _status = ConnectionStatus.online;
  StreamSubscription<ConnectivityResult>? _subscription;
  bool _wasOffline = false;

  ConnectivityService() {
    _initConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  ConnectionStatus get status => _status;
  bool get isOnline => _status == ConnectionStatus.online;
  bool get isOffline => _status == ConnectionStatus.offline;
  bool get justCameOnline => !_wasOffline && isOnline;

  Future<void> _initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final wasOffline = _status == ConnectionStatus.offline;
    
    // Check if connected
    if (result == ConnectivityResult.none) {
      _status = ConnectionStatus.offline;
    } else {
      _status = ConnectionStatus.online;
    }

    _wasOffline = wasOffline;
    notifyListeners();

    // Trigger sync when coming back online
    if (wasOffline && isOnline) {
      _onConnectionRestored();
    }
  }

  void _onConnectionRestored() {
    // Trigger sync operations
    debugPrint('Connection restored - triggering sync');
  }

  Future<bool> checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
