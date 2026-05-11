import 'package:flutter/material.dart';

import '../../core/enums/season.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SeasonBadge extends StatelessWidget {
  final Season season;
  final String? prefix;
  final bool compact;

  const SeasonBadge({
    super.key,
    required this.season,
    this.prefix,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 0.6),
      ),
      child: Text(
        prefix == null
            ? '${season.emoji} ${season.label}'
            : '${season.emoji} $prefix',
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}