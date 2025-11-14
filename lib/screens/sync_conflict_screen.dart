import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class SyncConflictScreen extends StatefulWidget {
  final Map<String, dynamic> localData;
  final Map<String, dynamic> serverData;
  final String dataType;

  const SyncConflictScreen({
    super.key,
    required this.localData,
    required this.serverData,
    required this.dataType,
  });

  @override
  State<SyncConflictScreen> createState() => _SyncConflictScreenState();
}

class _SyncConflictScreenState extends State<SyncConflictScreen> {
  final Map<String, String> _selections = {}; // field -> 'local' or 'server'
  late List<String> _conflictingFields;

  @override
  void initState() {
    super.initState();
    _conflictingFields = _findConflicts();
    // Default to server version
    for (final field in _conflictingFields) {
      _selections[field] = 'server';
    }
  }

  List<String> _findConflicts() {
    final conflicts = <String>[];
    final allKeys = {...widget.localData.keys, ...widget.serverData.keys};

    for (final key in allKeys) {
      if (widget.localData[key] != widget.serverData[key]) {
        conflicts.add(key);
      }
    }

    return conflicts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resolve Sync Conflict'),
        actions: [
          TextButton(
            onPressed: _resolveAutomatically,
            child: const Text(
              'Keep Server',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.warningAmber.withOpacity(0.2),
            child: Row(
              children: [
                const Icon(Icons.warning, color: AppTheme.warningAmber),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Data was changed both locally and on the server. Choose which version to keep for each field.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _conflictingFields.length,
              itemBuilder: (context, index) {
                final field = _conflictingFields[index];
                return _buildConflictCard(field);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.sacredBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Apply Selected Changes',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConflictCard(String field) {
    final localValue = widget.localData[field];
    final serverValue = widget.serverData[field];
    final selection = _selections[field];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatFieldName(field),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildVersionCard(
                    'Your Changes (Offline)',
                    localValue,
                    selection == 'local',
                    () => setState(() => _selections[field] = 'local'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildVersionCard(
                    'Server Data (Online)',
                    serverValue,
                    selection == 'server',
                    () => setState(() => _selections[field] = 'server'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionCard(
    String title,
    dynamic value,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.sacredBlue.withOpacity(0.1)
              : Colors.grey[100],
          border: Border.all(
            color: isSelected ? AppTheme.sacredBlue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: isSelected,
                  onChanged: (_) => onTap(),
                  activeColor: AppTheme.sacredBlue,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppTheme.sacredBlue : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value?.toString() ?? 'null',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFieldName(String field) {
    return field
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  void _resolveAutomatically() {
    Navigator.pop(context, widget.serverData);
  }

  void _applyChanges() {
    final resolvedData = <String, dynamic>{};

    // Start with all server data
    resolvedData.addAll(widget.serverData);

    // Override with selected local values
    for (final entry in _selections.entries) {
      if (entry.value == 'local') {
        resolvedData[entry.key] = widget.localData[entry.key];
      }
    }

    Navigator.pop(context, resolvedData);
  }
}
