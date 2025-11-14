import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/queue_manager.dart';
import '../services/sync_provider.dart';
import '../models/offline_action.dart';
import '../utils/app_theme.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Queue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _clearSuccessful(context),
          ),
        ],
      ),
      body: Consumer2<QueueManager, SyncProvider>(
        builder: (context, queue, sync, child) {
          if (queue.queue.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'All synced up!',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (queue.pendingCount > 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppTheme.warningAmber.withOpacity(0.2),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppTheme.warningAmber),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${queue.pendingCount} action(s) waiting to sync',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      if (!queue.isProcessing)
                        TextButton(
                          onPressed: () => sync.syncAll(),
                          child: const Text('Sync Now'),
                        ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: queue.queue.length,
                  itemBuilder: (context, index) {
                    final action = queue.queue[index];
                    return _buildActionCard(context, action, queue);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, OfflineAction action, QueueManager queue) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _getActionIcon(action),
        title: Text(_getActionTitle(action)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_formatTimestamp(action.timestamp)),
            if (action.retryCount > 0)
              Text(
                'Retried ${action.retryCount} time(s)',
                style: const TextStyle(fontSize: 12, color: AppTheme.warningAmber),
              ),
          ],
        ),
        trailing: _getStatusChip(action.status),
        onTap: () => _showActionDetails(context, action),
      ),
    );
  }

  Widget _getActionIcon(OfflineAction action) {
    IconData icon;
    Color color;

    switch (action.actionType) {
      case 'add_wishlist':
      case 'remove_wishlist':
        icon = Icons.favorite;
        color = AppTheme.errorRed;
        break;
      case 'write_review':
        icon = Icons.rate_review;
        color = AppTheme.goldenAccent;
        break;
      case 'update_profile':
        icon = Icons.person;
        color = AppTheme.sacredBlue;
        break;
      case 'submit_feedback':
        icon = Icons.feedback;
        color = Colors.green;
        break;
      default:
        icon = Icons.sync;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, color: color, size: 20),
    );
  }

  String _getActionTitle(OfflineAction action) {
    switch (action.actionType) {
      case 'add_wishlist':
        return 'Add to Wishlist';
      case 'remove_wishlist':
        return 'Remove from Wishlist';
      case 'write_review':
        return 'Submit Review';
      case 'update_profile':
        return 'Update Profile';
      case 'submit_feedback':
        return 'Submit Feedback';
      default:
        return action.actionType;
    }
  }

  Widget _getStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = AppTheme.warningAmber;
        label = 'Pending';
        break;
      case 'processing':
        color = Colors.blue;
        label = 'Processing';
        break;
      case 'success':
        color = AppTheme.successGreen;
        label = 'Success';
        break;
      case 'failed':
        color = AppTheme.errorRed;
        label = 'Failed';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  void _showActionDetails(BuildContext context, OfflineAction action) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getActionTitle(action),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Status', action.status),
            _buildDetailRow('Created', _formatTimestamp(action.timestamp)),
            _buildDetailRow('Retry Count', '${action.retryCount}'),
            const SizedBox(height: 16),
            const Text(
              'Payload:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                action.payload.toString(),
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 24),
            if (action.status == 'failed')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Provider.of<SyncProvider>(context, listen: false).retryAction(action);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.sacredBlue,
                  ),
                  child: const Text('Retry', style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(color: Colors.grey[700]),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _clearSuccessful(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Successful Actions'),
        content: const Text('Remove all successfully synced actions from the queue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<QueueManager>(context, listen: false).clearSuccessful();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Successful actions cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
