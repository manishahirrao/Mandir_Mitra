import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/connectivity_service.dart';
import '../../utils/app_theme.dart';

class OfflineErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final bool showSettings;

  const OfflineErrorWidget({
    super.key,
    this.message = 'This feature requires an internet connection',
    this.onRetry,
    this.showSettings = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No Internet Connection',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            Consumer<ConnectivityService>(
              builder: (context, connectivity, child) {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final isOnline = await connectivity.checkConnection();
                          if (isOnline && onRetry != null) {
                            onRetry!();
                          } else if (!isOnline && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Still offline. Check your connection.'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.sacredBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    if (showSettings) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/offline-storage-settings');
                          },
                          icon: const Icon(Icons.settings),
                          label: const Text('Offline Settings'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RequiresInternetWidget extends StatelessWidget {
  final String feature;
  final Widget child;

  const RequiresInternetWidget({
    super.key,
    required this.feature,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivity, _) {
        if (connectivity.isOffline) {
          return OfflineErrorWidget(
            message: '$feature requires an internet connection',
          );
        }
        return child;
      },
    );
  }
}

class OfflineDisabledButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  const OfflineDisabledButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivity, child) {
        final isDisabled = connectivity.isOffline || onPressed == null;
        
        Widget button = icon != null
            ? ElevatedButton.icon(
                onPressed: isDisabled ? null : onPressed,
                icon: Icon(icon),
                label: Text(
                  connectivity.isOffline
                      ? 'Requires Internet'
                      : label,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sacredBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: isDisabled ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sacredBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  connectivity.isOffline
                      ? 'Requires Internet'
                      : label,
                ),
              );

        if (fullWidth) {
          button = SizedBox(
            width: double.infinity,
            child: button,
          );
        }

        return Tooltip(
          message: connectivity.isOffline
              ? 'This feature requires an internet connection'
              : '',
          child: button,
        );
      },
    );
  }
}

class CachedBadge extends StatelessWidget {
  final String cacheKey;

  const CachedBadge({
    super.key,
    required this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isCached(),
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[700]?.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_done,
                size: 12,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              const Text(
                'Cached',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _isCached() async {
    // Import CacheManager and check
    // For now, return false as placeholder
    return false;
  }
}

class OfflineSearchDisabled extends StatelessWidget {
  const OfflineSearchDisabled({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          Icon(Icons.search_off, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search is unavailable offline',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
