import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/attraction.dart';

class PracticalInfoSection extends StatelessWidget {
  final Attraction attraction;
  const PracticalInfoSection({super.key, required this.attraction});

  @override
  Widget build(BuildContext context) {
    final tiles = <(String, String, String)>[
      ('🕐', 'Opening Hours', attraction.openingHours),
      ('💰', 'Admission', attraction.admissionFee),
      ('🅿️', 'Parking', attraction.parkingInfo),
      (
        '♿',
        'Accessibility',
        attraction.isWheelchairAccessible
            ? 'Wheelchair accessible'
            : 'Limited accessibility',
      ),
      ('💡', 'Best Time', attraction.bestTimeToVisit),
      (
        '👨‍👩‍👧‍👦',
        'Family Friendly',
        attraction.isFamilyFriendly
            ? 'Yes'
            : 'Not recommended for young children',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Practical Info',
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: AppColors.surface,
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: AppColors.divider,
                  splashColor: Colors.transparent,
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < tiles.length; i++) ...[
                      ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: Text(
                          tiles[i].$1,
                          style: const TextStyle(fontSize: 20),
                        ),
                        title: Text(
                          tiles[i].$2,
                          style: AppTextStyles.titleMedium,
                        ),
                        iconColor: AppColors.accent,
                        collapsedIconColor: AppColors.textSecondary,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                tiles[i].$3,
                                style: AppTextStyles.bodyMedium
                                    .copyWith(height: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (i < tiles.length - 1)
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}