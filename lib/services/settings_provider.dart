import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/app_settings.dart';

class SettingsProvider with ChangeNotifier {
  AppSettings _settings = AppSettings();
  int _versionTapCount = 0;

  SettingsProvider() {
    loadSettings();
  }

  AppSettings get settings => _settings;
  bool get isDeveloperMode => _versionTapCount >= 7;

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('app_settings');
      
      if (settingsJson != null) {
        _settings = AppSettings.fromJson(json.decode(settingsJson));
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
    notifyListeners();
  }

  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_settings', json.encode(_settings.toJson()));
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  Future<void> updateLanguage(AppLanguage language) async {
    _settings = _settings.copyWith(language: language);
    await saveSettings();
    notifyListeners();
  }

  Future<void> updateTheme(AppThemeMode theme) async {
    _settings = _settings.copyWith(themeMode: theme);
    await saveSettings();
    notifyListeners();
  }

  Future<void> updateFontSize(FontSize size) async {
    _settings = _settings.copyWith(fontSize: size);
    await saveSettings();
    notifyListeners();
  }

  Future<void> toggleNotifications(bool enabled) async {
    _settings = _settings.copyWith(notificationsEnabled: enabled);
    await saveSettings();
    notifyListeners();
  }

  Future<void> toggleSound(bool enabled) async {
    _settings = _settings.copyWith(soundEnabled: enabled);
    await saveSettings();
    notifyListeners();
  }

  Future<void> toggleVibration(bool enabled) async {
    _settings = _settings.copyWith(vibrationEnabled: enabled);
    await saveSettings();
    notifyListeners();
  }

  Future<void> setBiometric(bool enabled) async {
    _settings = _settings.copyWith(biometricEnabled: enabled);
    await saveSettings();
    notifyListeners();
  }

  Future<void> setPIN(String? pin) async {
    _settings = _settings.copyWith(pinCode: pin);
    await saveSettings();
    notifyListeners();
  }

  Future<void> setAutoLock(AutoLockDuration duration) async {
    _settings = _settings.copyWith(autoLockDuration: duration);
    await saveSettings();
    notifyListeners();
  }

  Future<void> toggleBetaFeatures(bool enabled) async {
    _settings = _settings.copyWith(betaFeaturesEnabled: enabled);
    await saveSettings();
    notifyListeners();
  }

  Future<double> clearCache() async {
    await Future.delayed(const Duration(seconds: 1));
    // In production, actually clear cache
    return 45.3; // Mock: freed MB
  }

  StorageInfo getStorageInfo() {
    // Mock storage info
    return StorageInfo(
      cacheSize: 45.3,
      downloadedFiles: 128.7,
      totalSize: 174.0,
    );
  }

  void incrementVersionTap() {
    _versionTapCount++;
    if (_versionTapCount >= 7) {
      notifyListeners();
    }
  }

  void resetVersionTap() {
    _versionTapCount = 0;
  }

  // Offline & Storage Settings
  bool get autoDownloadOnWifi => _settings.autoDownloadOnWifi;
  bool get autoSyncWhenOnline => _settings.autoSyncWhenOnline;
  String get downloadQuality => _settings.downloadQuality;
  int get storageLimitMB => _settings.storageLimitMB;
  bool get autoDeleteOldCache => _settings.autoDeleteOldCache;
  int get cacheExpiryDays => _settings.cacheExpiryDays;

  Future<void> setAutoDownloadOnWifi(bool value) async {
    _settings = _settings.copyWith(autoDownloadOnWifi: value);
    await saveSettings();
    notifyListeners();
  }

  Future<void> setAutoSyncWhenOnline(bool value) async {
    _settings = _settings.copyWith(autoSyncWhenOnline: value);
    await saveSettings();
    notifyListeners();
  }

  Future<void> setDownloadQuality(String quality) async {
    _settings = _settings.copyWith(downloadQuality: quality);
    await saveSettings();
    notifyListeners();
  }

  Future<void> setStorageLimit(int limitMB) async {
    _settings = _settings.copyWith(storageLimitMB: limitMB);
    await saveSettings();
    notifyListeners();
  }

  Future<void> setAutoDeleteOldCache(bool value) async {
    _settings = _settings.copyWith(autoDeleteOldCache: value);
    await saveSettings();
    notifyListeners();
  }

  Future<void> setCacheExpiryDays(int days) async {
    _settings = _settings.copyWith(cacheExpiryDays: days);
    await saveSettings();
    notifyListeners();
  }
}
