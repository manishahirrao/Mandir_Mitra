import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showRating;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 20,
    this.color,
    this.showRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          return Icon(
            _getStarIcon(index),
            size: size,
            color: color ?? AppTheme.divineGold,
          );
        }),
        if (showRating) ...[
          const SizedBox(width: 4),     
     Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  IconData _getStarIcon(int index) {
    final starValue = index + 1;
    if (rating >= starValue) {
      return Icons.star;
    } else if (rating >= starValue - 0.5) {
      return Icons.star_half;
    } else {
      return Icons.star_border;
    }
  }
}

class InteractiveStarRating extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;
  final double size;

  const InteractiveStarRating({
    super.key,
    this.initialRating = 0,
    required this.onRatingChanged,
    this.size = 40,
  });

  @override
  State<InteractiveStarRating> createState() => _InteractiveStarRatingState();
}

class _InteractiveStarRatingState extends State<InteractiveStarRating> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = (index + 1).toDouble();
            });
            widget.onRatingChanged(_rating);
          },
          child: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            size: widget.size,
            color: AppTheme.divineGold,
          ),
        );
      }),
    );
  }
}
