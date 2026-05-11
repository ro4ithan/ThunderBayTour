import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/attraction_scorer.dart';
import '../../../../domain/models/attraction.dart';
import '../../../providers/attractions_provider.dart';
import '../../../providers/saved_provider.dart';
import '../../../shared_widgets/rating_stars.dart';
import '../../../shared_widgets/shimmer_card.dart';
import '../../../../core/enums/saved_item_type.dart';

class GridAttractionCard extends ConsumerWidget {
  final Attraction attraction;
  const GridAttractionCard({super.key, required this.attraction});

  Color _badgeColor(AttractionFit fit) {
    switch (fit) {
      case AttractionFit.perfect:
        return const Color(0xFF52B788);
      case AttractionFit.good:
        return const Color(0xFF2A9D8F);
      case AttractionFit.betterIndoors:
        return const Color(0xFFE76F51);
      case AttractionFit.closedSeason:
        return Colors.grey;
      case AttractionFit.okay:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(savedProvider.select((list) =>
    list.any((s) => s.id == attraction.id && s.type == SavedItemType.attraction)));
    final score = ref.watch(attractionScoreProvider(attraction));
    final dim = score.fit == AttractionFit.closedSeason ||
        score.fit == AttractionFit.betterIndoors;

    return GestureDetector(
      onTap: () => context.push('/attraction/${attraction.id}'),
      child: Hero(
        tag: 'grid_${attraction.id}',
        child: Material(
          color: Colors.transparent,
          child: Opacity(
            opacity: dim ? 0.78 : 1.0,
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
                      // Fit badge (top-left)
                      if (score.badgeLabel != null)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _badgeColor(score.fit)
                                  .withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(score.badgeEmoji ?? '',
                                    style: const TextStyle(fontSize: 10)),
                                const SizedBox(width: 3),
                                Text(
                                  score.badgeLabel!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Saved indicator (top-right)
                      if (isSaved)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
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
                          style: AppTextStyles.titleMedium
                              .copyWith(fontSize: 14),
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
      ),
    );
  }
}