import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/ritual.dart';
import '../models/review.dart';
import '../widgets/ritual_detail/image_gallery.dart';
import '../widgets/ritual_detail/package_selector.dart';
import '../widgets/common/wishlist_button.dart';
import 'booking_screen.dart';

class RitualDetailScreen extends StatefulWidget {
  final Ritual ritual;

  const RitualDetailScreen({super.key, required this.ritual});

  @override
  State<RitualDetailScreen> createState() => _RitualDetailScreenState();
}

class _RitualDetailScreenState extends State<RitualDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isExpanded = false;
  String _selectedPackage = 'Family Package';
  double _selectedPrice = 501.0;

  final List<String> _images = [
    'https://images.unsplash.com/photo-1604608672516-f1b9b1b1c1c1',
    'https://images.unsplash.com/photo-1582510003544-4d00b7f74220',
    'https://images.unsplash.com/photo-1609619385002-f40f5e5c73b0',
    'https://images.unsplash.com/photo-1548625149-fc4a29cf7092',
    'https://images.unsplash.com/photo-1603048588665-791ca8aea617',
    'https://images.unsplash.com/photo-1599639957043-f3aa5c986398',
  ];

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
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 380,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: WishlistButton(
                      ritualId: widget.ritual.id,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: _showShareOptions,
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: ImageGallery(images: _images),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRitualInfo(),
                    const Divider(),
                    _buildPackageSelector(),
                    const Divider(),
                    _buildTabSection(),
                    _buildTempleInfo(),
                    _buildFAQs(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildRitualInfo() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.ritual.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.templeBrown,
                ),
          ),
          const SizedBox(height: AppTheme.spaceSM),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppTheme.earthTones),
                const SizedBox(width: 4),
                Text(
                  widget.ritual.templeName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.divineGold,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < 4 ? Icons.star : Icons.star_half,
                  color: AppTheme.saffronYellow,
                  size: 20,
                );
              }),
              const SizedBox(width: 8),
              Text(
                '4.5/5 (127 reviews)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMD),
          Text(
            widget.ritual.description,
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(_isExpanded ? 'Read Less' : 'Read More'),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageSelector() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      child: PackageSelector(
        onPackageSelected: (package, price) {
          setState(() {
            _selectedPackage = package;
            _selectedPrice = price;
          });
        },
      ),
    );
  }

  Widget _buildTabSection() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppTheme.divineGold,
          unselectedLabelColor: AppTheme.earthTones,
          indicatorColor: AppTheme.divineGold,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Process'),
            Tab(text: 'Aashirwad Box'),
            Tab(text: 'Reviews'),
          ],
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDetailsTab(),
              _buildProcessTab(),
              _buildAashirwadTab(),
              _buildReviewsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Full Description',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text(
            'This sacred ritual is performed with complete devotion and traditional methods. Our experienced pandits ensure every aspect of the ceremony is conducted according to ancient scriptures.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppTheme.spaceLG),
          Text(
            'Significance & Benefits',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          ...[
            'Removes obstacles and brings prosperity',
            'Provides divine protection and blessings',
            'Brings peace and harmony to family',
            'Fulfills wishes and desires',
          ].map((benefit) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spaceSM),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: AppTheme.successGreen, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(benefit)),
                  ],
                ),
              )),
          const SizedBox(height: AppTheme.spaceLG),
          Text(
            'Duration & Timing',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text('Duration: 2-3 hours\nBest Time: Morning (6 AM - 10 AM)'),
        ],
      ),
    );
  }

  Widget _buildProcessTab() {
    final steps = [
      {'icon': Icons.calendar_today, 'title': 'Booking Confirmation', 'desc': 'Your booking is confirmed and pandit is assigned'},
      {'icon': Icons.temple_hindu, 'title': 'Ritual Preparation', 'desc': 'All materials and offerings are prepared'},
      {'icon': Icons.videocam, 'title': 'Live Streaming', 'desc': 'Watch the ritual performed live via video'},
      {'icon': Icons.card_giftcard, 'title': 'Aashirwad Delivery', 'desc': 'Receive prasad and sacred items at home'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spaceLG),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.divineGold.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(step['icon'] as IconData, color: AppTheme.divineGold),
              ),
              const SizedBox(width: AppTheme.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step['desc'] as String,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAashirwadTab() {
    final contents = [
      {'icon': Icons.water_drop, 'name': 'Gangajal (Holy Water)'},
      {'icon': Icons.circle, 'name': 'Sacred Thread'},
      {'icon': Icons.circle_outlined, 'name': 'Kumkum & Haldi'},
      {'icon': Icons.food_bank, 'name': 'Prasad'},
      {'icon': Icons.spa, 'name': 'Rudraksha Beads'},
      {'icon': Icons.auto_awesome, 'name': 'Sacred Ash'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            child: Image.network(
              'https://images.unsplash.com/photo-1609619385002-f40f5e5c73b0',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: AppTheme.spaceLG),
          Text(
            'Box Contents',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          ...contents.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spaceSM),
                child: Row(
                  children: [
                    Icon(item['icon'] as IconData, color: AppTheme.divineGold),
                    const SizedBox(width: AppTheme.spaceSM),
                    Text(item['name'] as String),
                  ],
                ),
              )),
          const SizedBox(height: AppTheme.spaceLG),
          Text(
            'Delivery Timeline',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Text('Delivered within 3-5 business days after ritual completion'),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    // TODO: Fetch reviews from ReviewProvider
    final reviews = <Review>[];
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit),
            label: const Text('Write a Review'),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLG),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppTheme.spaceMD),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spaceMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(review.customerPhoto),
                          ),
                          const SizedBox(width: AppTheme.spaceSM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.customerName,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < review.rating ? Icons.star : Icons.star_border,
                                      color: AppTheme.saffronYellow,
                                      size: 16,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${review.date.day}/${review.date.month}/${review.date.year}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spaceSM),
                      Text(review.comment),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTempleInfo() {
    return ExpansionTile(
      leading: const Icon(Icons.temple_hindu, color: AppTheme.divineGold),
      title: Text(
        widget.ritual.templeName,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                child: Image.network(
                  'https://images.unsplash.com/photo-1609619385002-f40f5e5c73b0',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: AppTheme.spaceMD),
              Text(
                'A sacred temple with centuries of spiritual heritage. Known for its powerful divine presence and authentic rituals.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              TextButton(
                onPressed: () {},
                child: const Text('View Full Temple Details'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFAQs() {
    final faqs = [
      {'q': 'How long does the ritual take?', 'a': 'The ritual typically takes 2-3 hours to complete.'},
      {'q': 'Can I watch the ritual live?', 'a': 'Yes, you will receive a live streaming link before the ritual begins.'},
      {'q': 'When will I receive the Aashirwad Box?', 'a': 'The box will be delivered within 3-5 business days after the ritual.'},
      {'q': 'Can I reschedule my booking?', 'a': 'Yes, you can reschedule up to 24 hours before the scheduled time.'},
      {'q': 'What if I miss the live streaming?', 'a': 'A recording will be available for 30 days after the ritual.'},
    ];

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          ...faqs.map((faq) => ExpansionTile(
                leading: const Icon(Icons.help_outline, color: AppTheme.sacredBlue),
                title: Text(faq['q']!),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.spaceMD),
                    child: Text(faq['a']!),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        decoration: BoxDecoration(
          color: AppTheme.sacredWhite,
          boxShadow: [
            BoxShadow(
              color: AppTheme.sacredGrey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '₹${_selectedPrice.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.divineGold,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(width: AppTheme.spaceMD),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleBookNow,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceMD),
                    backgroundColor: AppTheme.divineGold,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Book Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBookNow() {
    // Extract package name from selected package (e.g., "Family Package" -> "Family")
    final packageName = _selectedPackage.replaceAll(' Package', '');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          ritual: widget.ritual,
          selectedPackage: packageName,
        ),
      ),
    );
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spaceLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share via',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spaceLG),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.message, 'WhatsApp', Colors.green),
                _buildShareOption(Icons.camera_alt, 'Instagram', Colors.purple),
                _buildShareOption(Icons.facebook, 'Facebook', Colors.blue),
              ],
            ),
            const SizedBox(height: AppTheme.spaceLG),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
