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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.white,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.black),
                      onPressed: _showShareOptions,
                    ),
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
                    _buildPackageSelector(),
                    _buildTabSection(),
                    _buildPujaProcess(),
                    _buildPujaBenefits(),
                    _buildFAQs(),
                    const SizedBox(height: 100),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '18,000 Puja Performed',
                  style: TextStyle(
                    color: Color(0xFFFF8C42),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.ritual.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ...List.generate(5, (index) {
                return const Icon(
                  Icons.star,
                  color: Color(0xFFFFB800),
                  size: 18,
                );
              }),
              const SizedBox(width: 8),
              const Text(
                '4.8 (2.5k reviews)',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.ritual.description,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF4B5563),
              height: 1.5,
            ),
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
            ),
            child: Text(
              _isExpanded ? 'Read Less' : 'Read More',
              style: const TextStyle(
                color: Color(0xFFFF8C42),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPujaProcess() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Puja Process',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          _buildProcessStep('1', 'Sankalp', 'Taking the resolution for the puja'),
          _buildProcessStep('2', 'Ganesh Puja', 'Invoking Lord Ganesha'),
          _buildProcessStep('3', 'Kalash Sthapana', 'Establishing the sacred pot'),
          _buildProcessStep('4', 'Main Puja', 'Performing the main ritual'),
          _buildProcessStep('5', 'Aarti & Prasad', 'Final offerings and blessings'),
        ],
      ),
    );
  }

  Widget _buildProcessStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C42),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPujaBenefits() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Puja Benefits',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          _buildBenefitItem('Removes obstacles and negativity'),
          _buildBenefitItem('Brings prosperity and success'),
          _buildBenefitItem('Provides divine protection'),
          _buildBenefitItem('Fulfills wishes and desires'),
          _buildBenefitItem('Brings peace and harmony'),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF10B981),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageSelector() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Puja Package',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          _buildPackageOption('Basic', 299, 'Essential puja items'),
          _buildPackageOption('Standard', 501, 'Complete puja with prasad'),
          _buildPackageOption('Premium', 1001, 'Full puja with live streaming'),
        ],
      ),
    );
  }

  Widget _buildPackageOption(String name, double price, String description) {
    final isSelected = _selectedPackage == '$name Package';
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPackage = '$name Package';
          _selectedPrice = price;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF8F0) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFFF8C42) : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFF8C42) : const Color(0xFFD1D5DB),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFFFF8C42) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFFFF8C42) : const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '₹${price.toInt()}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFFFF8C42) : const Color(0xFF2D3748),
              ),
            ),
          ],
        ),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _handleBookNow,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Book Puja',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
                const Spacer(),
                Text(
                  '₹${_selectedPrice.toInt()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
