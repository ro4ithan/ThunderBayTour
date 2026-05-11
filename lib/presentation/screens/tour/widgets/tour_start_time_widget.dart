import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/season_utils.dart';

class TourStartTimeWidget extends StatelessWidget {
  final String startTime;
  final String endTime;
  const TourStartTimeWidget({
    super.key,
    required this.startTime,
    required this.endTime,
  });

  /// Parses strings like "9:30 AM" / "10:05 PM" → minutes from midnight.
  double _toMinutes(String t) {
    try {
      final parts = t.trim().split(' ');
      if (parts.length != 2) return 720;
      final hm = parts[0].split(':');
      int h = int.parse(hm[0]);
      final m = int.parse(hm[1]);
      final isPm = parts[1].toUpperCase() == 'PM';
      if (isPm && h != 12) h += 12;
      if (!isPm && h == 12) h = 0;
      return (h * 60 + m).toDouble();
    } catch (_) {
      return 720;
    }
  }

  String _formatMinutes(double mins) {
    final total = mins.round();
    int h = (total ~/ 60) % 24;
    final m = total % 60;
    final ampm = h >= 12 ? 'PM' : 'AM';
    final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$h12:${m.toString().padLeft(2, '0')} $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final season = SeasonUtils.currentSeason().label.toLowerCase();
    final targetMinutes = _toMinutes(startTime);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_filled,
              color: AppColors.accent, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Best time to start:',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12)),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 720, end: targetMinutes),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder: (_, val, __) {
                    return Text(
                      _formatMinutes(val),
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                Text(
                  'Finish by ~$endTime · Perfect for $season daylight',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}