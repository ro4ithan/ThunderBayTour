import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/attraction.dart';

class IndigenousLegendSection extends StatelessWidget {
  final IndigenousLegend legend;
  const IndigenousLegendSection({super.key, required this.legend});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: const Border(
            left: BorderSide(color: AppColors.accent, width: 4),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🪶 Indigenous Legend',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              legend.title,
              style: AppTextStyles.titleLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              legend.story,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary.withOpacity(0.9),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              legend.culturalNote,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.accent.withOpacity(0.8),
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 500.ms).slideX(begin: 0.2, end: 0);
  }
}