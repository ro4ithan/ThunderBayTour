import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AttractionCategory {
  nature('Nature', Icons.forest_outlined, AppColors.natureGreen),
  history('History', Icons.account_balance_outlined, AppColors.historyBrown),
  culture('Culture', Icons.theater_comedy_outlined, AppColors.cultureViolet),
  waterfront('Waterfront', Icons.sailing_outlined, AppColors.waterfrontBlue),
  indigenous('Indigenous', Icons.eco_outlined, AppColors.indigenousAmber);

  final String label;
  final IconData icon;
  final Color color;

  const AttractionCategory(this.label, this.icon, this.color);

  static AttractionCategory fromString(String value) =>
      AttractionCategory.values.firstWhere(
        (c) => c.name == value.toLowerCase(),
        orElse: () => AttractionCategory.nature,
      );
}