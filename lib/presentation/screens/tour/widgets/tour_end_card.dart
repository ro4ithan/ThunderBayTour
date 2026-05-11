import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/tour_route.dart';

class TourEndCard extends StatelessWidget {
  final TourRoute tour;
  const TourEndCard({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    final totalMinutes = tour.totalDuration.inMinutes;
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    final stopCount = tour.totalStops;
    final km = tour.totalDistanceKm.toStringAsFixed(1);

    return TimelineTile(
      alignment: TimelineAlign.start,
      isLast: true,
      indicatorStyle: const IndicatorStyle(
        width: 36,
        indicator: CircleAvatar(
          backgroundColor: AppColors.accent,
          child: Text('🎉'),
        ),
      ),
      beforeLineStyle:
          const LineStyle(color: AppColors.accent, thickness: 2),
      endChild: Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 12),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: AppColors.accent.withValues(alpha: 0.12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'End of Tour 🎉',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                const Text("You've explored the best of Thunder Bay!"),
                const SizedBox(height: 8),
                Text(
                  '$stopCount stops · ${h}h ${m}m · $km km',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}