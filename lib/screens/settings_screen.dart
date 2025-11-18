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
      backgroundColor: const Color(0xFF1A1A1A),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Account Settings',
                style: TextStyle(
                  color: Color(0xFFFF8C42),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingTile(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                subtitle: 'Personal information, photo',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.lock_outline,
                title: 'Change Password',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.link,
                title: 'Linked Accounts',
                onTap: () {},
              ),
              const SizedBox(height: 24),
              const Text(
                'App Preferences',
                style: TextStyle(
                  color: Color(0xFFFF8C42),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingTileWithToggle(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                value: provider.settings.notificationsEnabled,
                onChanged: (value) => provider.toggleNotifications(value),
              ),
              _buildSettingTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
                onTap: () => _showLanguageSelector(context, provider),
              ),
              _buildSettingTileWithToggle(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Theme',
                value: true,
                onChanged: (value) {},
              ),
              _buildSettingTile(
                icon: Icons.security,
                title: 'Privacy & Security',
                onTap: () {},
              ),
              const SizedBox(height: 24),
              const Text(
                'Help & Support',
                style: TextStyle(
                  color: Color(0xFFFF8C42),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingTile(
                icon: Icons.help_outline,
                title: 'FAQ',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.headset_mic_outlined,
                title: 'Contact Us',
                onTap: () {},
              ),
              const SizedBox(height: 32),
              Center(
                child: TextButton(
                  onPressed: () => _logout(context),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0xFFFF4444),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'App Version 1.0.0',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
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

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF3A2A1A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFFF8C42), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 13,
                ),
              )
            : null,
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSettingTileWithToggle({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF3A2A1A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFFF8C42), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFFF8C42),
          activeTrackColor: const Color(0xFFFF8C42).withOpacity(0.5),
        ),
      ),
    );
  }

  String _getThemeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light';
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
