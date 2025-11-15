import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/rituals_provider.dart';
import '../widgets/services/ritual_grid.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RitualsProvider>(
      builder: (context, provider, child) {
        return const RitualGrid();
      },
    );
  }
}
