import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sync_provider.dart';
import '../models/offline_action.dart';
import '../utils/app_theme.dart';

class ManageDownloadsScreen extends StatefulWidget {
  const ManageDownloadsScreen({super.key});

  @override
  State<ManageDownloadsScreen> createState() => _ManageDownloadsScreenState();
}

class _ManageDownloadsScreenState extends State<ManageDownloadsScreen> {
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelectionMode ? '${_selectedIds.length} selected' : 'Manage Downloads'),
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelected,
            )
          else
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _showDeleteAllDialog,
            ),
        ],
      ),
      body: Consumer<SyncProvider>(
        builder: (context, syncProvider, child) {
          final downloads = syncProvider.downloads;
          final totalSize = syncProvider.totalDownloadSize;

          if (downloads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_download, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No downloaded content',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: AppTheme.sacredBlue.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Storage Used',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatBytes(totalSize),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.sacredBlue,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: downloads.length,
                  itemBuilder: (context, index) {
                    final download = downloads[index];
                    final isSelected = _selectedIds.contains(download.id);

                    return ListTile(
                      leading: _isSelectionMode
                          ? Checkbox(
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedIds.add(download.id);
                                  } else {
                                    _selectedIds.remove(download.id);
                                  }
                                });
                              },
                            )
                          : _getContentIcon(download.contentType),
                      title: Text(_getContentTitle(download)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(download.formattedSize),
                          Text(
                            'Downloaded ${_formatDate(download.downloadedAt)}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      trailing: _isSelectionMode
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deleteDownload(download),
                            ),
                      onLongPress: () {
                        setState(() {
                          _isSelectionMode = true;
                          _selectedIds.add(download.id);
                        });
                      },
                      onTap: _isSelectionMode
                          ? () {
                              setState(() {
                                if (isSelected) {
                                  _selectedIds.remove(download.id);
                                  if (_selectedIds.isEmpty) {
                                    _isSelectionMode = false;
                                  }
                                } else {
                                  _selectedIds.add(download.id);
                                }
                              });
                            }
                          : null,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Icon _getContentIcon(String contentType) {
    switch (contentType) {
      case 'ritual':
        return const Icon(Icons.temple_hindu, color: AppTheme.sacredBlue);
      case 'order':
        return const Icon(Icons.receipt_long, color: AppTheme.goldenAccent);
      case 'stream':
        return const Icon(Icons.video_library, color: AppTheme.errorRed);
      case 'invoice':
        return const Icon(Icons.description, color: Colors.green);
      default:
        return const Icon(Icons.file_present, color: Colors.grey);
    }
  }

  String _getContentTitle(DownloadedContent download) {
    switch (download.contentType) {
      case 'ritual':
        return 'Ritual Details';
      case 'order':
        return 'Order #${download.contentId}';
      case 'stream':
        return 'Stream Recording';
      case 'invoice':
        return 'Invoice';
      default:
        return 'Downloaded Content';
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _deleteDownload(DownloadedContent download) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Download'),
        content: const Text('Are you sure you want to delete this downloaded content?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<SyncProvider>(context, listen: false)
                  .deleteDownload(download.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Selected'),
        content: Text('Delete ${_selectedIds.length} downloaded items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final syncProvider = Provider.of<SyncProvider>(context, listen: false);
              for (final id in _selectedIds) {
                syncProvider.deleteDownload(id);
              }
              setState(() {
                _selectedIds.clear();
                _isSelectionMode = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloads deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Downloads'),
        content: const Text('This will delete all downloaded content. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<SyncProvider>(context, listen: false).clearAllDownloads();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All downloads deleted')),
              );
            },
            child: const Text('Delete All', style: TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
  }
}
