import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_provider.dart';
import '../services/auth_provider.dart';
import '../models/app_settings.dart';
import '../utils/app_theme.dart';
import '../widgets/settings/settings_tile.dart';
import '../widgets/settings/settings_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.sacredBlue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              SettingsSection(
                title: 'APP PREFERENCES',
                children: [
                  SettingsTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: provider.settings.getLanguageName(),
                    onTap: () => _showLanguageSelector(context, provider),
                  ),
                  SettingsTile(
                    icon: Icons.palette,
                    title: 'Appearance',
                    subtitle: _getThemeName(provider.settings.themeMode),
                    onTap: () => _showThemeSelector(context, provider),
                  ),
                  SettingsTile(
                    icon: Icons.text_fields,
                    title: 'Text Size',
                    subtitle: provider.settings.getFontSizeName(),
                    onTap: () => _showFontSizeSelector(context, provider),
                  ),
                ],
              ),
              SettingsSection(
                title: 'NOTIFICATIONS',
                children: [
                  SettingsTile(
                    icon: Icons.notifications,
                    title: 'Enable Notifications',
                    trailing: Switch(
                      value: provider.settings.notificationsEnabled,
                      onChanged: (value) => provider.toggleNotifications(value),
                      activeColor: AppTheme.sacredBlue,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.volume_up,
                    title: 'Sound',
                    trailing: Switch(
                      value: provider.settings.soundEnabled,
                      onChanged: (value) => provider.toggleSound(value),
                      activeColor: AppTheme.sacredBlue,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.vibration,
                    title: 'Vibration',
                    trailing: Switch(
                      value: provider.settings.vibrationEnabled,
                      onChanged: (value) => provider.toggleVibration(value),
                      activeColor: AppTheme.sacredBlue,
                    ),
                  ),
                ],
              ),
              SettingsSection(
                title: 'PRIVACY & SECURITY',
                children: [
                  SettingsTile(
                    icon: Icons.fingerprint,
                    title: 'Biometric Login',
                    trailing: Switch(
                      value: provider.settings.biometricEnabled,
                      onChanged: (value) => provider.setBiometric(value),
                      activeColor: AppTheme.sacredBlue,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.lock,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.description,
                    title: 'Terms & Conditions',
                    onTap: () {},
                  ),
                ],
              ),
              SettingsSection(
                title: 'CACHE & STORAGE',
                children: [
                  SettingsTile(
                    icon: Icons.storage,
                    title: 'Storage',
                    subtitle: provider.getStorageInfo().totalSizeFormatted,
                    onTap: () => _showStorageInfo(context, provider),
                  ),
                  SettingsTile(
                    icon: Icons.delete_sweep,
                    title: 'Clear Cache',
                    onTap: () => _clearCache(context, provider),
                  ),
                ],
              ),
              SettingsSection(
                title: 'ABOUT',
                children: [
                  SettingsTile(
                    icon: Icons.info,
                    title: 'App Version',
                    subtitle: '1.0.0 (Build 23)',
                    onTap: () => provider.incrementVersionTap(),
                  ),
                  SettingsTile(
                    icon: Icons.star,
                    title: 'Rate Us',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.share,
                    title: 'Share App',
                    onTap: () {},
                  ),
                ],
              ),
              if (provider.isDeveloperMode)
                SettingsSection(
                  title: 'DEVELOPER MODE',
                  children: [
                    SettingsTile(
                      icon: Icons.bug_report,
                      title: 'Beta Features',
                      trailing: Switch(
                        value: provider.settings.betaFeaturesEnabled,
                        onChanged: (value) => provider.toggleBetaFeatures(value),
                        activeColor: AppTheme.sacredBlue,
                      ),
                    ),
                    SettingsTile(
                      icon: Icons.code,
                      title: 'Debug Mode',
                      subtitle: 'Developer options enabled',
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorRed,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  String _getThemeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System Default';
    }
  }

  void _showLanguageSelector(BuildContext context, SettingsProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Language',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...AppLanguage.values.map((lang) => RadioListTile<AppLanguage>(
                  title: Text(_getLanguageName(lang)),
                  value: lang,
                  groupValue: provider.settings.language,
                  onChanged: (value) {
                    if (value != null) {
                      provider.updateLanguage(value);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Language updated')),
                      );
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(AppLanguage lang) {
    switch (lang) {
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

  void _showThemeSelector(BuildContext context, SettingsProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...AppThemeMode.values.map((mode) => RadioListTile<AppThemeMode>(
                  title: Text(_getThemeName(mode)),
                  value: mode,
                  groupValue: provider.settings.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      provider.updateTheme(value);
                      Navigator.pop(context);
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showFontSizeSelector(BuildContext context, SettingsProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Text Size',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...FontSize.values.map((size) => RadioListTile<FontSize>(
                  title: Text(
                    _getFontSizeName(size),
                    style: TextStyle(fontSize: 16 * _getFontMultiplier(size)),
                  ),
                  value: size,
                  groupValue: provider.settings.fontSize,
                  onChanged: (value) {
                    if (value != null) {
                      provider.updateFontSize(value);
                      Navigator.pop(context);
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  String _getFontSizeName(FontSize size) {
    switch (size) {
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

  double _getFontMultiplier(FontSize size) {
    switch (size) {
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

  void _showStorageInfo(BuildContext context, SettingsProvider provider) {
    final storage = provider.getStorageInfo();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cache: ${storage.cacheSizeFormatted}'),
            Text('Downloads: ${storage.downloadedFilesFormatted}'),
            Text('Total: ${storage.totalSizeFormatted}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _clearCache(BuildContext context, SettingsProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final freed = await provider.clearCache();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cache cleared. Freed ${freed.toStringAsFixed(1)} MB')),
        );
      }
    }
  }

  void _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await Provider.of<AuthProvider>(context, listen: false).logout();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }
}
