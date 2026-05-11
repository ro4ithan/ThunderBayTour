import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/attraction.dart';
import '../../../providers/saved_provider.dart';
import '../../../shared_widgets/rating_stars.dart';
import '../../../shared_widgets/shimmer_card.dart';

class GridAttractionCard extends ConsumerWidget {
  final Attraction attraction;
  const GridAttractionCard({super.key, required this.attraction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedProvider);
    final isSaved = saved.any((s) => s.attractionId == attraction.id);

    return GestureDetector(
      onTap: () => context.push('/attraction/${attraction.id}'),
      child: Hero(
        tag: 'grid_${attraction.id}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: attraction.imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          const ShimmerCard(height: 120, borderRadius: 0),
                      errorWidget: (_, __, ___) => Container(
                        height: 120,
                        color: AppColors.divider,
                        child: Icon(
                          attraction.category.icon,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    if (isSaved)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bookmark,
                            color: AppColors.accent,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attraction.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          RatingStars(rating: attraction.rating, size: 11),
                          const SizedBox(width: 4),
                          Text(
                            attraction.rating.toStringAsFixed(1),
                            style: AppTextStyles.labelSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '📍 ${attraction.distanceFromDowntown}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: attraction.bestSeasons
                            .take(3)
                            .map(
                              (s) => Text(
                                s.emoji,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}