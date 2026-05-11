import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class StatsRow extends StatelessWidget {
  final double rating;
  final int visitMinutes;
  final double distanceKm;

  const StatsRow({
    super.key,
    required this.rating,
    required this.visitMinutes,
    required this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StatCard(
        icon: '⭐',
        endValue: rating,
        decimals: 1,
        suffix: '',
        label: 'Rating',
        semantic: 'Rating: ${rating.toStringAsFixed(1)} out of 5',
      ),
      _StatCard(
        icon: '🕐',
        endValue: visitMinutes.toDouble(),
        decimals: 0,
        suffix: '',
        label: 'Visit Time',
        formatter: (v) => '${(v / 60).toStringAsFixed(1)} hrs',
        semantic:
            'Suggested visit: ${(visitMinutes / 60).toStringAsFixed(1)} hours',
      ),
      _StatCard(
        icon: '📍',
        endValue: distanceKm,
        decimals: 0,
        suffix: ' km',
        label: 'Distance',
        semantic: '${distanceKm.toStringAsFixed(0)} kilometers from downtown',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            Expanded(
              child: cards[i]
                  .animate(delay: (200 * i).ms)
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: 0.2, end: 0),
            ),
            if (i < cards.length - 1) const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final double endValue;
  final int decimals;
  final String suffix;
  final String label;
  final String semantic;
  final String Function(double)? formatter;

  const _StatCard({
    required this.icon,
    required this.endValue,
    required this.decimals,
    required this.suffix,
    required this.label,
    required this.semantic,
    this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semantic,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: endValue),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (_, value, __) {
                final text = formatter != null
                    ? formatter!(value)
                    : '${value.toStringAsFixed(decimals)}$suffix';
                return Text(
                  text,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w800,
                  ),
                );
              },
            ),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.labelSmall),
          ],
        ),
      ),
    );
  }
}
