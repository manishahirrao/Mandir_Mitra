import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class LovedOnesScreen extends StatefulWidget {
  const LovedOnesScreen({super.key});

  @override
  State<LovedOnesScreen> createState() => _LovedOnesScreenState();
}

class _LovedOnesScreenState extends State<LovedOnesScreen> {
  final List<Map<String, String>> _lovedOnes = [
    {
      'name': 'Sunita Sharma',
      'relation': 'Mother',
      'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
    },
    {
      'name': 'Rohan Patel',
      'relation': 'Father',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
    },
    {
      'name': 'Priya Singh',
      'relation': 'Spouse',
      'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _lovedOnes.length,
              itemBuilder: (context, index) {
                final person = _lovedOnes[index];
                return _buildLovedOneCard(person, index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: _showAddLovedOneDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C42),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Add Loved One',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLovedOneCard(Map<String, String> person, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(person['image']!),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      person['relation']!,
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showRemoveDialog(person['name']!, index),
                  icon: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                  label: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF4A4A4A)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showEditDialog(person, index),
                  icon: const Icon(Icons.edit, color: Color(0xFFFF8C42), size: 18),
                  label: const Text(
                    'Edit',
                    style: TextStyle(color: Color(0xFFFF8C42), fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF8C42)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddLovedOneDialog() {
    final nameController = TextEditingController();
    final relationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Add Loved One', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A4A4A)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF8C42)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: relationController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Relation',
                labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A4A4A)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF8C42)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF9CA3AF))),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && relationController.text.isNotEmpty) {
                setState(() {
                  _lovedOnes.add({
                    'name': nameController.text,
                    'relation': relationController.text,
                    'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e',
                  });
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C42)),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, String> person, int index) {
    final nameController = TextEditingController(text: person['name']);
    final relationController = TextEditingController(text: person['relation']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Edit Loved One', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A4A4A)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF8C42)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: relationController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Relation',
                labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A4A4A)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF8C42)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF9CA3AF))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _lovedOnes[index] = {
                  'name': nameController.text,
                  'relation': relationController.text,
                  'image': person['image']!,
                };
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C42)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(String name, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Remove Loved One', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to remove $name?',
          style: const TextStyle(color: Color(0xFF9CA3AF)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF9CA3AF))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _lovedOnes.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
