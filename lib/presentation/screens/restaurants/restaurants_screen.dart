import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/restaurants_provider.dart';
import 'widgets/restaurant_card.dart';
import 'widgets/restaurant_category_chips.dart';

/// Main Restaurants screen — filter chips + scrollable list.
class RestaurantsScreen extends ConsumerWidget {
  const RestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurants = ref.watch(filteredRestaurantsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(count: restaurants.length),
            const SizedBox(height: 12),
            const RestaurantCategoryChips(),
            const SizedBox(height: 8),
            Expanded(
              child: restaurants.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 100),
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        final r = restaurants[index];
                        return RestaurantCard(
                          restaurant: r,
                          onTap: () => context.push('/restaurant/${r.id}'),
                        )
                            .animate()
                            .fadeIn(
                              delay: Duration(milliseconds: index * 60),
                              duration: const Duration(milliseconds: 400),
                            )
                            .slideY(
                              begin: 0.15,
                              end: 0,
                              delay: Duration(milliseconds: index * 60),
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                            );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.no_meals,
              size: 56, color: AppColors.textSecondary.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Text(
            'No restaurants in this category',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Eat & Drink', style: AppTextStyles.titleLarge),
                const SizedBox(height: 4),
                Text(
                  '$count spots in Thunder Bay',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.restaurant_menu, color: AppColors.accent, size: 28),
        ],
      ),
    );
  }
}
