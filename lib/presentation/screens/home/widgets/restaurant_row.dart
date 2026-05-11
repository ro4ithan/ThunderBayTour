import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/restaurant.dart';
import '../../../providers/attractions_provider.dart';
import '../../../shared_widgets/rating_stars.dart';
import '../../../shared_widgets/shimmer_card.dart';

class RestaurantRow extends ConsumerWidget {
  const RestaurantRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurants = ref.watch(restaurantsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Text('Local Eats 🍽️', style: AppTextStyles.headlineMedium),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Authentic Thunder Bay flavors',
            style: AppTextStyles.bodyMedium,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: restaurants.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              return _RestaurantCard(restaurant: restaurants[i])
                  .animate(delay: (80 * i).ms)
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: 0.2, end: 0);
            },
          ),
        ),
      ],
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: restaurant.imageUrl,
                width: 160,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    const ShimmerCard(width: 160, height: 100),
                errorWidget: (_, __, ___) => Container(
                  width: 160,
                  height: 100,
                  color: AppColors.divider,
                  child: const Icon(
                    Icons.restaurant,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              if (restaurant.isLocalFavorite)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '⭐ Local Fav',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
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
                  restaurant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  restaurant.cuisine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    RatingStars(rating: restaurant.rating, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.rating.toStringAsFixed(1),
                      style: AppTextStyles.labelSmall,
                    ),
                    const Spacer(),
                    Text(
                      restaurant.priceRange,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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