import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSearchHeader(),
          _buildFilterChips(),
          _buildFeaturedBanner(),
          _buildEverydayRituals(),
          _buildLifeBenefitPujas(),
          _buildDoshNivaran(),
          _buildSpecialOccasions(),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Public Rituals',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.sacredGrey,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for rituals, deities...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterDrawer(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Everyday', 'Life Benefits', 'Dosh Removal', 'Special', 'This Week', 'Premium'];
    
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final filter = filters[index];
            final isSelected = selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => selectedFilter = filter);
                },
                selectedColor: AppTheme.goldenAccent,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.sacredGrey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppTheme.sacredGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '11,000 Santan Gopal Mantra Jaap',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Maha Havan - Special Event',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '⏰ 2 days left',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '👥 45/100 slots',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.goldenAccent,
                foregroundColor: AppTheme.sacredGrey,
              ),
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEverydayRituals() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Everyday Rituals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                final deities = ['Maa Kali', 'Lord Shiva', 'Lord Ganesha', 'Maa Lakshmi', 'Lord Hanuman'];
                return _buildDeityCard(deities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeityCard(String deity) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: AppTheme.templeCream,
            child: const Icon(Icons.temple_hindu, size: 35, color: AppTheme.sacredBlue),
          ),
          const SizedBox(height: 8),
          Text(deity, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Daily 6 AM', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text('👥 25', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          const Text('₹301', style: TextStyle(color: AppTheme.sacredBlue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 30)),
            child: const Text('Join Today', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildLifeBenefitPujas() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Life Benefit Pujas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildBenefitCard('💼', 'Career &\nSuccess'),
                _buildBenefitCard('💑', 'Marriage &\nLove'),
                _buildBenefitCard('🏥', 'Health &\nHealing'),
                _buildBenefitCard('💰', 'Wealth &\nProsperity'),
                _buildBenefitCard('🎓', 'Education\nSuccess'),
                _buildBenefitCard('🏠', 'Home &\nFamily'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCard(String emoji, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoshNivaran() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Remove Astrological Doshas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDoshCard('Pitra Dosha', 'Ancestral blessings', '20 Nov', '₹701'),
            _buildDoshCard('Manglik Dosha', 'Marriage harmony', '22 Nov', '₹901'),
            _buildDoshCard('Kaal Sarp Dosha', 'Remove obstacles', '25 Nov', '₹1,101'),
          ],
        ),
      ),
    );
  }

  Widget _buildDoshCard(String name, String desc, String date, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.templeCream,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_fix_high, color: AppTheme.sacredBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text('📅 $date', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.sacredBlue)),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.goldenAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                ),
                child: const Text('Book', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialOccasions() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Special Occasions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildOccasionCard('Ekadashi Special', '1008 Kamal Archana', 'Ettelutherumal Temple', '15 Nov', '45/100', '₹501'),
            _buildOccasionCard('Purnima Puja', 'Satyanarayan Katha', 'Tirupati Temple', '18 Nov', '30/80', '₹701'),
          ],
        ),
      ),
    );
  }

  Widget _buildOccasionCard(String title, String ritual, String temple, String date, String slots, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.goldenAccent.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.goldenAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('📅 $title', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('🔹 $ritual', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text('📍 $temple', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text('🗓️ $date, Saturday', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('👥 $slots Slots Filled', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              Row(
                children: [
                  Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.sacredBlue)),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldenAccent),
                    child: const Text('PARTICIPATE →'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['Daily', 'Special', 'Dosha', 'Life Benefits'].map((cat) {
                        return FilterChip(label: Text(cat), onSelected: (val) {});
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold)),
                    RangeSlider(values: const RangeValues(300, 1000), min: 100, max: 2000, onChanged: (val) {}),
                    const SizedBox(height: 16),
                    const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold)),
                    RadioListTile(title: const Text('Upcoming Date'), value: 1, groupValue: 1, onChanged: (val) {}),
                    RadioListTile(title: const Text('Price (Low to High)'), value: 2, groupValue: 1, onChanged: (val) {}),
                    RadioListTile(title: const Text('Popularity'), value: 3, groupValue: 1, onChanged: (val) {}),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldenAccent),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
