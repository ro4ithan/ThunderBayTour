import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/attraction.dart';
import '../../../shared_widgets/rating_stars.dart';
import '../../../shared_widgets/shimmer_card.dart';

class SimilarAttractions extends StatelessWidget {
  final List<Attraction> items;
  const SimilarAttractions({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
          child: Text(
            'You Might Also Like',
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final a = items[i];
              return GestureDetector(
                onTap: () =>
                    context.push('/attraction/${a.id}', extra: a),
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: a.imageUrl,
                        width: 140,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            const ShimmerCard(width: 140, height: 100),
                        errorWidget: (_, __, ___) => Container(
                          height: 100,
                          color: AppColors.divider,
                          child: Icon(a.category.icon),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.titleMedium
                                  .copyWith(fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                RatingStars(rating: a.rating, size: 11),
                                const SizedBox(width: 4),
                                Text(
                                  a.rating.toStringAsFixed(1),
                                  style: AppTextStyles.labelSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate(delay: (100 * i).ms)
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: 0.2, end: 0);
            },
          ),
        ),
      ],
    );
  }
}