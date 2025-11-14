import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../services/wishlist_provider.dart';
import '../services/rituals_provider.dart';
import '../models/ritual.dart';
import '../utils/app_theme.dart';
import '../widgets/services/ritual_card.dart';
import 'ritual_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _isGridView = true;
  bool _isSelectMode = false;
  final Set<String> _selectedItems = {};
  String _sortBy = 'recent';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer2<WishlistProvider, RitualsProvider>(
        builder: (context, wishlistProvider, ritualsProvider, child) {
          final wishlistRituals = wishlistProvider.getWishlistRituals(
            ritualsProvider.rituals,
          );

          final filteredRituals = _searchQuery.isEmpty
              ? wishlistRituals
              : wishlistRituals
                  .where((r) => r.name
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()))
                  .toList();

          if (wishlistProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (filteredRituals.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => wishlistProvider.syncWithServer(),
            child: Column(
              children: [
                _buildTopBar(wishlistRituals, ritualsProvider.rituals),
                Expanded(
                  child: _isGridView
                      ? _buildGridView(filteredRituals)
                      : _buildListView(filteredRituals),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _isSelectMode ? _buildBottomActionBar() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Consumer<WishlistProvider>(
        builder: (context, provider, child) {
          return Text('Wishlist (${provider.wishlistCount})');
        },
      ),
      backgroundColor: AppTheme.sacredBlue,
      foregroundColor: Colors.white,
      actions: [
        if (!_isSelectMode)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        if (!_isSelectMode)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'share') {
                _shareWishlist();
              } else if (value == 'clear') {
                _showClearDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 12),
                    Text('Share Wishlist'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Clear Wishlist', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTopBar(List<Ritual> rituals, List<Ritual> allRituals) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _sortBy,
              decoration: const InputDecoration(
                labelText: 'Sort by',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'recent', child: Text('Recently Added')),
                DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                DropdownMenuItem(value: 'name', child: Text('Name (A-Z)')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _sortBy = value);
                  _applySorting(allRituals);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() => _isGridView = !_isGridView);
            },
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.sacredBlue.withOpacity(0.1),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(_isSelectMode ? Icons.close : Icons.checklist),
            onPressed: () {
              setState(() {
                _isSelectMode = !_isSelectMode;
                if (!_isSelectMode) {
                  _selectedItems.clear();
                }
              });
            },
            style: IconButton.styleFrom(
              backgroundColor: _isSelectMode
                  ? AppTheme.sacredBlue
                  : AppTheme.sacredBlue.withOpacity(0.1),
              foregroundColor: _isSelectMode ? Colors.white : AppTheme.sacredBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<Ritual> rituals) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: rituals.length,
      itemBuilder: (context, index) {
        final ritual = rituals[index];
        return _buildGridItem(ritual);
      },
    );
  }

  Widget _buildListView(List<Ritual> rituals) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rituals.length,
      itemBuilder: (context, index) {
        final ritual = rituals[index];
        return _buildListItem(ritual);
      },
    );
  }

  Widget _buildGridItem(Ritual ritual) {
    final isSelected = _selectedItems.contains(ritual.id);

    return GestureDetector(
      onTap: () {
        if (_isSelectMode) {
          setState(() {
            if (isSelected) {
              _selectedItems.remove(ritual.id);
            } else {
              _selectedItems.add(ritual.id);
            }
          });
        } else {
          _navigateToDetail(ritual);
        }
      },
      onLongPress: () {
        if (!_isSelectMode) {
          setState(() {
            _isSelectMode = true;
            _selectedItems.add(ritual.id);
          });
        }
      },
      child: Stack(
        children: [
          RitualCard(ritual: ritual),
          if (_isSelectMode)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedItems.add(ritual.id);
                      } else {
                        _selectedItems.remove(ritual.id);
                      }
                    });
                  },
                  activeColor: AppTheme.sacredBlue,
                ),
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: _buildWishlistButton(ritual.id),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(Ritual ritual) {
    final isSelected = _selectedItems.contains(ritual.id);

    return Dismissible(
      key: Key(ritual.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppTheme.errorRed,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _removeFromWishlist(ritual.id);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () {
            if (_isSelectMode) {
              setState(() {
                if (isSelected) {
                  _selectedItems.remove(ritual.id);
                } else {
                  _selectedItems.add(ritual.id);
                }
              });
            } else {
              _navigateToDetail(ritual);
            }
          },
          onLongPress: () {
            if (!_isSelectMode) {
              setState(() {
                _isSelectMode = true;
                _selectedItems.add(ritual.id);
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (_isSelectMode)
                  Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedItems.add(ritual.id);
                        } else {
                          _selectedItems.remove(ritual.id);
                        }
                      });
                    },
                    activeColor: AppTheme.sacredBlue,
                  ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    ritual.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ritual.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ritual.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'From ₹${ritual.price}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.templeBrown,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildWishlistButton(ritual.id),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistButton(String ritualId) {
    return Consumer<WishlistProvider>(
      builder: (context, provider, child) {
        final isInWishlist = provider.isInWishlist(ritualId);
        return IconButton(
          icon: Icon(
            isInWishlist ? Icons.favorite : Icons.favorite_border,
            color: isInWishlist ? Colors.red : Colors.grey,
          ),
          onPressed: () => _toggleWishlist(ritualId),
        );
      },
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '${_selectedItems.length} selected',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _selectedItems.isEmpty ? null : _shareSelected,
            icon: const Icon(Icons.share),
            label: const Text('Share'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.sacredBlue,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _selectedItems.isEmpty ? null : _removeSelected,
            icon: const Icon(Icons.delete),
            label: const Text('Remove'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Your Wishlist is Empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Browse rituals and save your favorites here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sacredBlue,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Explore Rituals',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applySorting(List<Ritual> allRituals) {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    switch (_sortBy) {
      case 'recent':
        provider.sortByRecentlyAdded();
        break;
      case 'price_low':
        provider.sortByPriceLowToHigh(allRituals);
        break;
      case 'price_high':
        provider.sortByPriceHighToLow(allRituals);
        break;
      case 'name':
        provider.sortByName(allRituals);
        break;
    }
  }

  void _toggleWishlist(String ritualId) async {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    final wasInWishlist = provider.isInWishlist(ritualId);
    
    await provider.toggleWishlist(ritualId);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            wasInWishlist ? 'Removed from Wishlist' : 'Added to Wishlist',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _removeFromWishlist(String ritualId) async {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    await provider.removeFromWishlist(ritualId);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from Wishlist'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _removeSelected() async {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    await provider.removeMultiple(_selectedItems.toList());
    
    setState(() {
      _selectedItems.clear();
      _isSelectMode = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Items removed from wishlist')),
      );
    }
  }

  void _shareSelected() {
    final ritualsProvider = Provider.of<RitualsProvider>(context, listen: false);
    final selectedRituals = ritualsProvider.rituals
        .where((r) => _selectedItems.contains(r.id))
        .toList();
    
    final ritualNames = selectedRituals.map((r) => r.name).join(', ');
    final shareText = 'Check out my wishlist on Mandir Mitra: $ritualNames\n\nDownload the app: https://mandirmitra.app';
    
    Share.share(shareText);
  }

  void _shareWishlist() {
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final ritualsProvider = Provider.of<RitualsProvider>(context, listen: false);
    
    final wishlistRituals = wishlistProvider.getWishlistRituals(
      ritualsProvider.rituals,
    );
    
    if (wishlistRituals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your wishlist is empty')),
      );
      return;
    }
    
    final ritualNames = wishlistRituals.map((r) => r.name).join(', ');
    final shareText = 'Check out my wishlist on Mandir Mitra: $ritualNames\n\nDownload the app: https://mandirmitra.app';
    
    Share.share(shareText);
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Wishlist'),
        content: const Text('Are you sure you want to remove all items from your wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<WishlistProvider>(context, listen: false).clearWishlist();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wishlist cleared')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Wishlist'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter ritual name...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = '');
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(Ritual ritual) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RitualDetailScreen(ritual: ritual),
      ),
    );
  }
}
