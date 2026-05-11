import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/restaurant.dart';
import '../../../providers/restaurants_provider.dart';
import '../../../shared_widgets/rating_stars.dart';
import '../../../shared_widgets/shimmer_card.dart';

class RestaurantRow extends ConsumerWidget {
  const RestaurantRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(allRestaurantsProvider);

    // Top-rated, capped at 6 for the home rail.
    final topPicks = [...all]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final list = topPicks.take(6).toList();

    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Text('Where to Eat 🍽️',
                    style: AppTextStyles.headlineMedium),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.push('/restaurants'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See all',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.arrow_forward_ios,
                          size: 12, color: AppColors.accent),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
          child: Text(
            'Authentic Thunder Bay flavours',
            style: AppTextStyles.bodyMedium,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              return _MiniRestaurantCard(restaurant: list[i])
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

class _MiniRestaurantCard extends StatefulWidget {
  final Restaurant restaurant;
  const _MiniRestaurantCard({required this.restaurant});

  @override
  State<_MiniRestaurantCard> createState() => _MiniRestaurantCardState();
}

class _MiniRestaurantCardState extends State<_MiniRestaurantCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () => context.push('/restaurant/${r.id}'),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: r.imageUrl,
                    width: 160,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const ShimmerCard(width: 160, height: 100),
                    errorWidget: (_, __, ___) => Image.asset(
                      r.localImagePath,
                      width: 160,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 160,
                        height: 100,
                        color: AppColors.divider,
                        child: const Icon(Icons.restaurant,
                            color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  if (r.isLocalFavorite)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
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
                      r.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          AppTextStyles.titleMedium.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      r.cuisine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        RatingStars(rating: r.rating, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          r.rating.toStringAsFixed(1),
                          style: AppTextStyles.labelSmall,
                        ),
                        const Spacer(),
                        Text(
                          r.priceRange,
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
        ),
      ),
    );
  }
}