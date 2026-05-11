import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/category.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../providers/attractions_provider.dart';

class IndigenousSpotlight extends ConsumerWidget {
  const IndigenousSpotlight({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🪶', style: TextStyle(fontSize: 26)),
                const SizedBox(width: 10),
                Text(
                  'Indigenous Thunder Bay',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Discover the stories of the Anishinaabe people — the original stewards of this land.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.accent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  ref.read(categoryFilterProvider.notifier).state =
                      AttractionCategory.indigenous;
                },
                child: const Text('Explore Indigenous Sites →'),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.15, end: 0);
  }
}