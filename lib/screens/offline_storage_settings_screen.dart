import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_provider.dart';
import '../services/sync_provider.dart';
import '../utils/app_theme.dart';

class OfflineStorageSettingsScreen extends StatelessWidget {
  const OfflineStorageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline & Storage'),
      ),
      body: Consumer2<SettingsProvider, SyncProvider>(
        builder: (context, settings, sync, child) {
          return ListView(
            children: [
              _buildSection(
                'Download Settings',
                [
                  SwitchListTile(
                    title: const Text('Auto-download on WiFi'),
                    subtitle: const Text('Automatically cache new content when connected to WiFi'),
                    value: settings.autoDownloadOnWifi,
                    onChanged: (value) => settings.setAutoDownloadOnWifi(value),
                    activeColor: AppTheme.sacredBlue,
                  ),
                  ListTile(
                    title: const Text('Download Quality'),
                    subtitle: Text(_getQualityText(settings.downloadQuality)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showQualityDialog(context, settings),
                  ),
                ],
              ),
              _buildSection(
                'Sync Settings',
                [
                  SwitchListTile(
                    title: const Text('Auto-sync when online'),
                    subtitle: const Text('Automatically sync queued actions when connection restored'),
                    value: settings.autoSyncWhenOnline,
                    onChanged: (value) => settings.setAutoSyncWhenOnline(value),
                    activeColor: AppTheme.sacredBlue,
                  ),
                ],
              ),
              _buildSection(
                'Storage Management',
                [
                  ListTile(
                    title: const Text('Storage Limit'),
                    subtitle: Text('${settings.storageLimitMB} MB'),
                    trailing: Text(
                      '${sync.totalDownloadSize ~/ (1024 * 1024)} MB used',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Slider(
                      value: settings.storageLimitMB.toDouble(),
                      min: 100,
                      max: 2000,
                      divisions: 19,
                      label: '${settings.storageLimitMB} MB',
                      onChanged: (value) => settings.setStorageLimit(value.toInt()),
                      activeColor: AppTheme.sacredBlue,
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Auto-delete old cache'),
                    subtitle: Text('Remove cache older than ${settings.cacheExpiryDays} days'),
                    value: settings.autoDeleteOldCache,
                    onChanged: (value) => settings.setAutoDeleteOldCache(value),
                    activeColor: AppTheme.sacredBlue,
                  ),
                  if (settings.autoDeleteOldCache)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cache expiry: ${settings.cacheExpiryDays} days'),
                          Slider(
                            value: settings.cacheExpiryDays.toDouble(),
                            min: 1,
                            max: 30,
                            divisions: 6,
                            label: '${settings.cacheExpiryDays} days',
                            onChanged: (value) => settings.setCacheExpiryDays(value.toInt()),
                            activeColor: AppTheme.sacredBlue,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              _buildSection(
                'Cache Actions',
                [
                  ListTile(
                    leading: const Icon(Icons.cleaning_services, color: AppTheme.sacredBlue),
                    title: const Text('Clear Expired Cache'),
                    subtitle: const Text('Remove outdated cached data'),
                    onTap: () => _clearExpiredCache(context, sync),
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_sweep, color: AppTheme.errorRed),
                    title: const Text('Clear All Cache'),
                    subtitle: const Text('Remove all cached data'),
                    onTap: () => _clearAllCache(context, sync),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.sacredBlue,
            ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }

  String _getQualityText(String quality) {
    switch (quality) {
      case 'high':
        return 'High (Original quality)';
      case 'medium':
        return 'Medium (Compressed)';
      case 'low':
        return 'Low (Highly compressed)';
      default:
        return 'Medium';
    }
  }

  void _showQualityDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('High'),
              subtitle: const Text('Original quality, larger files'),
              value: 'high',
              groupValue: settings.downloadQuality,
              onChanged: (value) {
                settings.setDownloadQuality(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Medium'),
              subtitle: const Text('Balanced quality and size'),
              value: 'medium',
              groupValue: settings.downloadQuality,
              onChanged: (value) {
                settings.setDownloadQuality(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Low'),
              subtitle: const Text('Smaller files, lower quality'),
              value: 'low',
              groupValue: settings.downloadQuality,
              onChanged: (value) {
                settings.setDownloadQuality(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearExpiredCache(BuildContext context, SyncProvider sync) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Expired Cache'),
        content: const Text('Remove all outdated cached data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await sync.cleanExpiredCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expired cache cleared')),
                );
              }
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _clearAllCache(BuildContext context, SyncProvider sync) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Cache'),
        content: const Text('This will remove all cached data. You may need to re-download content. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await sync.clearAllCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All cache cleared')),
                );
              }
            },
            child: const Text('Clear All', style: TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
  }
}
