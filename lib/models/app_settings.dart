enum AppLanguage {
  english,
  hindi,
  bengali,
  tamil,
  telugu,
}

enum AppThemeMode {
  light,
}

enum FontSize {
  small,
  defaultSize,
  large,
  extraLarge,
}

enum AutoLockDuration {
  immediately,
  oneMinute,
  fiveMinutes,
  never,
}

class AppSettings {
  final AppLanguage language;
  final AppThemeMode themeMode;
  final FontSize fontSize;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool biometricEnabled;
  final String? pinCode;
  final AutoLockDuration autoLockDuration;
  final bool betaFeaturesEnabled;
  
  // Offline & Storage Settings
  final bool autoDownloadOnWifi;
  final bool autoSyncWhenOnline;
  final String downloadQuality; // 'high', 'medium', 'low'
  final int storageLimitMB;
  final bool autoDeleteOldCache;
  final int cacheExpiryDays;

  AppSettings({
    this.language = AppLanguage.english,
    this.themeMode = AppThemeMode.light,
    this.fontSize = FontSize.defaultSize,
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.biometricEnabled = false,
    this.pinCode,
    this.autoLockDuration = AutoLockDuration.never,
    this.betaFeaturesEnabled = false,
    this.autoDownloadOnWifi = true,
    this.autoSyncWhenOnline = true,
    this.downloadQuality = 'medium',
    this.storageLimitMB = 500,
    this.autoDeleteOldCache = true,
    this.cacheExpiryDays = 7,
  });

  String getLanguageName() {
    switch (language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.hindi:
        return 'हिंदी (Hindi)';
      case AppLanguage.bengali:
        return 'বাংলা (Bengali)';
      case AppLanguage.tamil:
        return 'தமிழ் (Tamil)';
      case AppLanguage.telugu:
        return 'తెలుగు (Telugu)';
    }
  }

  double getFontSizeMultiplier() {
    switch (fontSize) {
      case FontSize.small:
        return 0.85;
      case FontSize.defaultSize:
        return 1.0;
      case FontSize.large:
        return 1.15;
      case FontSize.extraLarge:
        return 1.3;
    }
  }

  String getFontSizeName() {
    switch (fontSize) {
      case FontSize.small:
        return 'Small';
      case FontSize.defaultSize:
        return 'Default';
      case FontSize.large:
        return 'Large';
      case FontSize.extraLarge:
        return 'Extra Large';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language.toString(),
      'themeMode': themeMode.toString(),
      'fontSize': fontSize.toString(),
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'biometricEnabled': biometricEnabled,
      'pinCode': pinCode,
      'autoLockDuration': autoLockDuration.toString(),
      'betaFeaturesEnabled': betaFeaturesEnabled,
      'autoDownloadOnWifi': autoDownloadOnWifi,
      'autoSyncWhenOnline': autoSyncWhenOnline,
      'downloadQuality': downloadQuality,
      'storageLimitMB': storageLimitMB,
      'autoDeleteOldCache': autoDeleteOldCache,
      'cacheExpiryDays': cacheExpiryDays,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      language: AppLanguage.values.firstWhere(
        (e) => e.toString() == json['language'],
        orElse: () => AppLanguage.english,
      ),
      themeMode: AppThemeMode.light,
      fontSize: FontSize.values.firstWhere(
        (e) => e.toString() == json['fontSize'],
        orElse: () => FontSize.defaultSize,
      ),
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      biometricEnabled: json['biometricEnabled'] ?? false,
      pinCode: json['pinCode'],
      autoLockDuration: AutoLockDuration.values.firstWhere(
        (e) => e.toString() == json['autoLockDuration'],
        orElse: () => AutoLockDuration.never,
      ),
      betaFeaturesEnabled: json['betaFeaturesEnabled'] ?? false,
      autoDownloadOnWifi: json['autoDownloadOnWifi'] ?? true,
      autoSyncWhenOnline: json['autoSyncWhenOnline'] ?? true,
      downloadQuality: json['downloadQuality'] ?? 'medium',
      storageLimitMB: json['storageLimitMB'] ?? 500,
      autoDeleteOldCache: json['autoDeleteOldCache'] ?? true,
      cacheExpiryDays: json['cacheExpiryDays'] ?? 7,
    );
  }

  AppSettings copyWith({
    AppLanguage? language,
    AppThemeMode? themeMode,
    FontSize? fontSize,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? biometricEnabled,
    String? pinCode,
    AutoLockDuration? autoLockDuration,
    bool? betaFeaturesEnabled,
    bool? autoDownloadOnWifi,
    bool? autoSyncWhenOnline,
    String? downloadQuality,
    int? storageLimitMB,
    bool? autoDeleteOldCache,
    int? cacheExpiryDays,
  }) {
    return AppSettings(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinCode: pinCode ?? this.pinCode,
      autoLockDuration: autoLockDuration ?? this.autoLockDuration,
      betaFeaturesEnabled: betaFeaturesEnabled ?? this.betaFeaturesEnabled,
      autoDownloadOnWifi: autoDownloadOnWifi ?? this.autoDownloadOnWifi,
      autoSyncWhenOnline: autoSyncWhenOnline ?? this.autoSyncWhenOnline,
      downloadQuality: downloadQuality ?? this.downloadQuality,
      storageLimitMB: storageLimitMB ?? this.storageLimitMB,
      autoDeleteOldCache: autoDeleteOldCache ?? this.autoDeleteOldCache,
      cacheExpiryDays: cacheExpiryDays ?? this.cacheExpiryDays,
    );
  }
}

class StorageInfo {
  final double cacheSize;
  final double downloadedFiles;
  final double totalSize;

  StorageInfo({
    required this.cacheSize,
    required this.downloadedFiles,
    required this.totalSize,
  });

  String get cacheSizeFormatted => '${cacheSize.toStringAsFixed(1)} MB';
  String get downloadedFilesFormatted => '${downloadedFiles.toStringAsFixed(1)} MB';
  String get totalSizeFormatted => '${totalSize.toStringAsFixed(1)} MB';
}
