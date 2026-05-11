import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/restaurant.dart';
import '../../../providers/restaurants_provider.dart';

/// Horizontal scrollable chip row for filtering restaurants by category.
class RestaurantCategoryChips extends ConsumerWidget {
  const RestaurantCategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedRestaurantCategoryProvider);

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _Chip(
            label: 'All',
            isSelected: selected == null,
            onTap: () => ref
                .read(selectedRestaurantCategoryProvider.notifier)
                .state = null,
          ),
          ...RestaurantCategory.values.map(
            (cat) => _Chip(
              label: _labelFor(cat),
              isSelected: selected == cat,
              onTap: () => ref
                  .read(selectedRestaurantCategoryProvider.notifier)
                  .state = cat,
            ),
          ),
        ],
      ),
    );
  }

  String _labelFor(RestaurantCategory cat) {
    switch (cat) {
      case RestaurantCategory.fineDining:
        return 'Fine Dining';
      case RestaurantCategory.casual:
        return 'Casual';
      case RestaurantCategory.international:
        return 'International';
      case RestaurantCategory.brewery:
        return 'Brewery';
      case RestaurantCategory.cocktailBar:
        return 'Cocktail Bar';
      case RestaurantCategory.bakery:
        return 'Bakery';
      case RestaurantCategory.cafe:
        return 'Café';
      case RestaurantCategory.market:
        return 'Market';
      case RestaurantCategory.indigenous:
        return 'Indigenous';
      case RestaurantCategory.specialty:
        return 'Specialty';
      case RestaurantCategory.vegetarian:
        return 'Vegetarian';
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: isSelected ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent
                  : AppColors.surface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected
                    ? AppColors.accent
                    : AppColors.textSecondary.withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected
                    ? AppColors.background
                    : AppColors.textSecondary.withValues(alpha: 0.85),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
