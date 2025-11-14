import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/connectivity_service.dart';
import '../../utils/app_theme.dart';

class OfflineBanner extends StatefulWidget {
  final Widget child;

  const OfflineBanner({super.key, required this.child});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _showOnlineMessage = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivity, child) {
        // Handle animation based on connection status
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (connectivity.isOffline) {
            _controller.forward();
            _showOnlineMessage = false;
          } else if (connectivity.justCameOnline && !_showOnlineMessage) {
            _showOnlineMessage = true;
            _controller.forward();
            // Hide "back online" message after 2 seconds
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                _controller.reverse();
                setState(() {
                  _showOnlineMessage = false;
                });
              }
            });
          } else if (connectivity.isOnline && !_showOnlineMessage) {
            _controller.reverse();
          }
        });

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              widget.child,
              if (connectivity.isOffline || _showOnlineMessage)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildBanner(connectivity.isOffline),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBanner(bool isOffline) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isOffline ? Colors.orange : Colors.green,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(
              isOffline ? Icons.wifi_off : Icons.wifi,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isOffline
                    ? "You're offline. Some features may not be available."
                    : "Back online",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
