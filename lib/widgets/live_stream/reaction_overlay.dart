import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/live_stream_provider.dart';
import '../../models/live_stream.dart';

class ReactionOverlay extends StatelessWidget {
  final String streamId;

  const ReactionOverlay({super.key, required this.streamId});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildReactionButton(context, '❤️', ReactionType.heart),
        const SizedBox(height: 8),
        _buildReactionButton(context, '🙏', ReactionType.foldedHands),
        const SizedBox(height: 8),
        _buildReactionButton(context, '🕉️', ReactionType.om),
      ],
    );
  }

  Widget _buildReactionButton(
    BuildContext context,
    String emoji,
    ReactionType type,
  ) {
    return GestureDetector(
      onTap: () {
        Provider.of<LiveStreamProvider>(context, listen: false)
            .sendReaction(streamId, type);
        _showFloatingReaction(context, emoji);
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  void _showFloatingReaction(BuildContext context, String emoji) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => FloatingReaction(emoji: emoji),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

class FloatingReaction extends StatefulWidget {
  final String emoji;

  const FloatingReaction({super.key, required this.emoji});

  @override
  State<FloatingReaction> createState() => _FloatingReactionState();
}

class _FloatingReactionState extends State<FloatingReaction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -200),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          right: 80,
          bottom: 100 + _positionAnimation.value.dy,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Text(
              widget.emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        );
      },
    );
  }
}
