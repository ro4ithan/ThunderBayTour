import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/models/restaurant.dart';
import '../../providers/restaurants_provider.dart';
import '../../shared_widgets/rating_stars.dart';
import 'widgets/signature_dish_card.dart';
import 'widgets/weekly_hours_section.dart';
import 'widgets/save_restaurant_button.dart';
import 'widgets/restaurant_action_bar.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  const RestaurantDetailScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurant = ref.watch(restaurantByIdProvider(restaurantId));

    if (restaurant == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.background),
        body: Center(
          child: Text('Restaurant not found', style: AppTextStyles.bodyLarge),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _SliverHero(restaurant: restaurant),
          SliverToBoxAdapter(child: _Body(restaurant: restaurant)),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: SaveRestaurantButton(restaurantId: restaurant.id),
              ),
              RestaurantActionBar(restaurant: restaurant),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverHero extends StatelessWidget {
  const _SliverHero({required this.restaurant});
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.background,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: restaurant.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: AppColors.surface,
                highlightColor: AppColors.textSecondary.withValues(alpha: 0.1),
                child: Container(color: AppColors.surface),
              ),
              errorWidget: (_, __, ___) => Image.asset(
                restaurant.localImagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: AppColors.surface),
              ),
            ),
            // Gradient overlay for legibility
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.95),
                  ],
                  stops: const [0.45, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.restaurant});
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final r = restaurant;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(r.name, style: AppTextStyles.headlineLarge)
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
          const SizedBox(height: 6),
          Text(
            r.cuisine,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          // Rating + price + favourite
          Row(
            children: [
              RatingStars(rating: r.rating, size: 16),
              const SizedBox(width: 8),
              Text(r.rating.toStringAsFixed(1),
                  style: AppTextStyles.labelLarge),
              const SizedBox(width: 14),
              Text('•',
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColors.textSecondary)),
              const SizedBox(width: 14),
              Text(
                r.priceRange,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (r.isLocalFavorite)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: AppColors.accent, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        'Local Fav',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 22),

          // Description
          Text(r.description, style: AppTextStyles.bodyLarge),
          const SizedBox(height: 22),

          // Specialties chips
          if (r.specialties.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  r.specialties.map((s) => _SpecialtyChip(label: s)).toList(),
            ),
            const SizedBox(height: 26),
          ],

          // Hours
          const _SectionTitle('Hours'),
          const SizedBox(height: 10),
          WeeklyHoursSection(weeklyHours: r.weeklyHours),
          const SizedBox(height: 26),

          // Address
          const _SectionTitle('Address'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on,
                    color: AppColors.accent, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(r.address, style: AppTextStyles.bodyMedium),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),

          // Signature dishes
          if (r.signatureDishes.isNotEmpty) ...[
            const _SectionTitle('Signature Dishes'),
            const SizedBox(height: 10),
            ...r.signatureDishes.asMap().entries.map((entry) {
              return SignatureDishCard(dish: entry.value)
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 100 * entry.key),
                    duration: 350.ms,
                  )
                  .slideX(
                    begin: 0.15,
                    end: 0,
                    delay: Duration(milliseconds: 100 * entry.key),
                    curve: Curves.easeOutCubic,
                  );
            }),
            const SizedBox(height: 18),
          ],

          // Must try dishes (simple chip list)
          if (r.mustTryDishes.isNotEmpty) ...[
            const _SectionTitle('Must Try'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  r.mustTryDishes.map((d) => _MustTryChip(label: d)).toList(),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTextStyles.headlineMedium);
}

class _SpecialtyChip extends StatelessWidget {
  const _SpecialtyChip({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent),
      ),
    );
  }
}

class _MustTryChip extends StatelessWidget {
  const _MustTryChip({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.restaurant, size: 12, color: AppColors.accent),
          const SizedBox(width: 5),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}
