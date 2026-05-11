import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared_widgets/shimmer_card.dart';

class GallerySection extends StatelessWidget {
  final List<String> images;
  const GallerySection({super.key, required this.images});

  void _openImage(BuildContext context, String url) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (_, __) => const ShimmerCard(height: 300),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
          child: Text(
            'Gallery',
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () => _openImage(context, images[i]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: images[i],
                    width: 150,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const ShimmerCard(width: 150, height: 120),
                    errorWidget: (_, __, ___) => Container(
                      width: 150,
                      height: 120,
                      color: AppColors.divider,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              )
                  .animate(delay: (80 * i).ms)
                  .fadeIn(duration: 350.ms)
                  .slideX(begin: 0.2, end: 0);
            },
          ),
        ),
      ],
    );
  }
}