import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/sync_provider.dart';
import '../../services/queue_manager.dart';
import '../../utils/app_theme.dart';

class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SyncProvider, QueueManager>(
      builder: (context, sync, queue, child) {
        return IconButton(
          icon: Stack(
            children: [
              _buildSyncIcon(sync, queue),
              if (queue.pendingCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppTheme.warningAmber,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${queue.pendingCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () => _showSyncDetails(context, sync, queue),
        );
      },
    );
  }

  Widget _buildSyncIcon(SyncProvider sync, QueueManager queue) {
    if (queue.isProcessing) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.sacredBlue),
        ),
      );
    }

    if (queue.getFailedActions().isNotEmpty) {
      return const Icon(Icons.sync_problem, color: AppTheme.errorRed);
    }

    if (queue.pendingCount > 0) {
      return const Icon(Icons.sync, color: AppTheme.warningAmber);
    }

    return const Icon(Icons.cloud_done, color: AppTheme.successGreen);
  }

  void _showSyncDetails(BuildContext context, SyncProvider sync, QueueManager queue) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sync Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatusRow(
              'Last Synced',
              sync.lastSyncTime != null
                  ? _formatTime(sync.lastSyncTime!)
                  : 'Never',
              Icons.access_time,
            ),
            const SizedBox(height: 8),
            _buildStatusRow(
              'Pending Actions',
              '${queue.pendingCount}',
              Icons.pending_actions,
              color: queue.pendingCount > 0 ? AppTheme.warningAmber : null,
            ),
            const SizedBox(height: 8),
            _buildStatusRow(
              'Failed Actions',
              '${queue.getFailedActions().length}',
              Icons.error_outline,
              color: queue.getFailedActions().isNotEmpty ? AppTheme.errorRed : null,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/queue');
                    },
                    child: const Text('View Queue'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: queue.isProcessing
                        ? null
                        : () async {
                            Navigator.pop(context);
                            await sync.syncAll();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sync completed')),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.sacredBlue,
                    ),
                    child: const Text('Sync Now', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, IconData icon, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
