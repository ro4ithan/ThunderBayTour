import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../providers/sort_provider.dart';

class SortSelector extends ConsumerWidget {
  const SortSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(sortProvider);
    return Row(
      children: [
        _item(ref, current, SortOption.recentlyAdded, 'Recently Added'),
        _item(ref, current, SortOption.rating, 'Rating'),
        _item(ref, current, SortOption.distance, 'Distance'),
      ],
    );
  }

  Widget _item(WidgetRef ref, SortOption current, SortOption opt, String label) {
    final active = current == opt;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => ref.read(sortProvider.notifier).state = opt,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Text(
                label,
                style: TextStyle(
                  color: active
                      ? AppColors.accent
                      : Colors.white.withValues(alpha: 0.6),
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              height: 2,
              width: active ? label.length * 7.5 : 0,
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}