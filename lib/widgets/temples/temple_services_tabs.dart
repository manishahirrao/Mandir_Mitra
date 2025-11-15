import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/temple.dart';
import '../../services/temple_provider.dart';
import '../../utils/app_theme.dart';

class TempleServicesTabs extends StatefulWidget {
  final Temple temple;

  const TempleServicesTabs({Key? key, required this.temple}) : super(key: key);

  @override
  State<TempleServicesTabs> createState() => _TempleServicesTabsState();
}

class _TempleServicesTabsState extends State<TempleServicesTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      color: Colors.white,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryOrange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryOrange,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Chadhava'),
              Tab(text: 'Pujas'),
              Tab(text: 'Live Darshan'),
              Tab(text: 'Aartis'),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChadhavaTab(),
                _buildPujasTab(),
                _buildLiveDarshanTab(),
                _buildAartisTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChadhavaTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Temple-Specific Chadhava',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryOrange,
          ),
        ),
        const SizedBox(height: 12),
        ...widget.temple.servicesOffered.map((service) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text('🙏', style: TextStyle(fontSize: 20)),
              ),
              title: Text(service),
              subtitle: const Text('Traditional offering'),
              trailing: const Text('From ₹51', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening $service details...')),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPujasTab() {
    final pujas = context.read<TempleProvider>().getTemplePujas(widget.temple.id);
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: pujas.map((puja) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  puja.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  puja.description,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('${puja.durationMinutes} mins'),
                    const SizedBox(width: 16),
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        puja.nextAvailableSlot ?? 'On request',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: puja.packages.entries.map((entry) {
                    return Chip(
                      label: Text('${entry.key}: ₹${entry.value.toInt()}'),
                      backgroundColor: AppTheme.primaryOrange.withOpacity(0.1),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                    ),
                    child: const Text('BOOK NOW'),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLiveDarshanTab() {
    if (!widget.temple.hasLiveDarshan) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                'Live Darshan Coming Soon',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'We are working to bring live darshan from this temple',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Request This Feature'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_outline, size: 64),
                SizedBox(height: 8),
                Text('Live Stream Placeholder'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Live Darshan Schedule',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryOrange,
          ),
        ),
        const SizedBox(height: 12),
        ...?widget.temple.liveDarshanSchedule?.map((time) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.videocam, color: Colors.red),
              title: Text(time),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Notify Me'),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAartisTab() {
    if (widget.temple.aartis == null || widget.temple.aartis!.isEmpty) {
      return const Center(child: Text('No aarti information available'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: widget.temple.aartis!.map((aarti) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      aarti.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getAartiColor(aarti.type),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        aarti.time,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  aarti.description,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sponsor: ₹${aarti.sponsorPrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryOrange,
                      ),
                      child: const Text('SPONSOR'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getAartiColor(String type) {
    switch (type) {
      case 'morning':
        return Colors.orange;
      case 'afternoon':
        return Colors.amber;
      case 'evening':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }
}
