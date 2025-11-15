import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/temple_provider.dart';
import '../utils/app_theme.dart';

class TempleComparisonScreen extends StatelessWidget {
  const TempleComparisonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Temples'),
        backgroundColor: AppTheme.primaryOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              context.read<TempleProvider>().clearComparison();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Consumer<TempleProvider>(
        builder: (context, provider, child) {
          final temples = provider.comparisonList;

          if (temples.isEmpty) {
            return const Center(
              child: Text('No temples selected for comparison'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Temple Headers
                Container(
                  height: 200,
                  child: Row(
                    children: temples.map((temple) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryOrange.withOpacity(0.6),
                                AppTheme.secondaryOrange.withOpacity(0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🕉️', style: TextStyle(fontSize: 40)),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  temple.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Comparison Rows
                _buildComparisonRow('Location', temples.map((t) => t.fullLocation).toList()),
                _buildComparisonRow('Rating', temples.map((t) => '⭐ ${t.rating}').toList()),
                _buildComparisonRow('Reviews', temples.map((t) => '${t.reviewCount}').toList()),
                _buildComparisonRow('Category', temples.map((t) => t.category ?? 'N/A').toList()),
                _buildComparisonRow('Deity', temples.map((t) => t.presidingDeity ?? 'N/A').toList()),
                _buildComparisonRow('Timings', temples.map((t) => t.timings).toList()),
                _buildComparisonRow(
                  'Live Darshan',
                  temples.map((t) => t.hasLiveDarshan ? '✓ Available' : '✗ Not Available').toList(),
                ),
                _buildComparisonRow(
                  'Services',
                  temples.map((t) => '${t.servicesOffered.length} services').toList(),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildComparisonRow(String title, List<String> values) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Row(
            children: values.map((value) {
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
