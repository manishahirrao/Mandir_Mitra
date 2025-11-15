import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class TempleImageCarousel extends StatefulWidget {
  final List<String> images;

  const TempleImageCarousel({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  State<TempleImageCarousel> createState() => _TempleImageCarouselState();
}

class _TempleImageCarouselState extends State<TempleImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryOrange.withOpacity(0.6),
                    AppTheme.secondaryOrange.withOpacity(0.6),
                  ],
                ),
              ),
              child: const Center(
                child: Text('🕉️', style: TextStyle(fontSize: 100)),
              ),
            );
          },
        ),
        
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),
        
        // Page indicator
        if (widget.images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
