import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class ImageGallery extends StatefulWidget {
  final List<String> images;

  const ImageGallery({super.key, required this.images});

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _openLightbox(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ImageLightbox(
          images: widget.images,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _openLightbox(index),
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.templeCream,
                          child: const Icon(
                            Icons.temple_hindu,
                            size: 80,
                            color: AppTheme.divineGold,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: AppTheme.spaceMD,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? AppTheme.divineGold
                          : AppTheme.sacredWhite.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSM),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _currentIndex == index
                          ? AppTheme.divineGold
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ImageLightbox extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _ImageLightbox({
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_ImageLightbox> createState() => _ImageLightboxState();
}

class _ImageLightboxState extends State<_ImageLightbox> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openLightbox(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ImageLightbox(
          images: widget.images,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Center(
                  child: Image.network(
                    widget.images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceMD),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_currentIndex + 1}/${widget.images.length}',
                    style: const TextStyle(
                      color: AppTheme.sacredWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.sacredWhite),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
