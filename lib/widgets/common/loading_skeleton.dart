import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class RitualCardSkeleton extends StatelessWidget {
  const RitualCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingSkeleton(
            width: double.infinity,
            height: 180,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoadingSkeleton(width: 150, height: 20),
                const SizedBox(height: 8),
                const LoadingSkeleton(width: 100, height: 16),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    LoadingSkeleton(width: 80, height: 16),
                    LoadingSkeleton(width: 60, height: 32),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RitualGridSkeleton extends StatelessWidget {
  const RitualGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const RitualCardSkeleton(),
    );
  }
}

class OrderListSkeleton extends StatelessWidget {
  const OrderListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  LoadingSkeleton(width: 60, height: 60),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LoadingSkeleton(width: double.infinity, height: 18),
                        SizedBox(height: 8),
                        LoadingSkeleton(width: 120, height: 14),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  LoadingSkeleton(width: 80, height: 16),
                  LoadingSkeleton(width: 100, height: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileInfoSkeleton extends StatelessWidget {
  const ProfileInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const LoadingSkeleton(
          width: 100,
          height: 100,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        const SizedBox(height: 16),
        const LoadingSkeleton(width: 150, height: 24),
        const SizedBox(height: 8),
        const LoadingSkeleton(width: 200, height: 16),
        const SizedBox(height: 24),
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: const [
                      LoadingSkeleton(width: 40, height: 40),
                      SizedBox(width: 16),
                      Expanded(child: LoadingSkeleton(width: double.infinity, height: 16)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BlogPostSkeleton extends StatelessWidget {
  const BlogPostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingSkeleton(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                LoadingSkeleton(width: double.infinity, height: 20),
                SizedBox(height: 8),
                LoadingSkeleton(width: double.infinity, height: 16),
                SizedBox(height: 4),
                LoadingSkeleton(width: 200, height: 16),
                SizedBox(height: 12),
                LoadingSkeleton(width: 120, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const CustomLoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class FullScreenLoader extends StatelessWidget {
  final String? message;

  const FullScreenLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomLoadingIndicator(),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
