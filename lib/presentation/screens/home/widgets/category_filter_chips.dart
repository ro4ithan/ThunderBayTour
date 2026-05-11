import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/category.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../providers/attractions_provider.dart';

class CategoryFilterChips extends ConsumerWidget {
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(categoryFilterProvider);
    final entries = <(AttractionCategory?, String, IconData?)>[
      (null, 'All', Icons.apps_rounded),
      ...AttractionCategory.values.map((c) => (c, c.label, c.icon)),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (cat, label, icon) = entries[i];
          final isActive = selected == cat;
          return GestureDetector(
            onTap: () =>
                ref.read(categoryFilterProvider.notifier).state = cat,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              scale: isActive ? 1.05 : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isActive
                        ? AppColors.accent
                        : AppColors.divider,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 16,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      label,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate(delay: (80 * i).ms)
              .fadeIn(duration: 350.ms)
              .slideX(begin: 0.3, end: 0);
        },
      ),
    );
  }
}