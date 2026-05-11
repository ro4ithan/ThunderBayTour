import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../providers/tour_planner_provider.dart';

class TourHeader extends StatelessWidget {
  final TourPlan plan;
  final DateTime startTime;
  final VoidCallback onPickTime;
  final VoidCallback onOpenMaps;
  final VoidCallback onClear;

  const TourHeader({
    super.key,
    required this.plan,
    required this.startTime,
    required this.onPickTime,
    required this.onOpenMaps,
    required this.onClear,
  });

  String _fmtTime(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final ap = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ap';
  }

  String _fmtDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h == 0) return '${m}m';
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Your Tour', style: AppTextStyles.headlineLarge),
              ),
              IconButton(
                tooltip: 'Clear tour',
                onPressed: onClear,
                icon: const Icon(Icons.delete_sweep_outlined,
                    color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${plan.stops.length} stops • ${_fmtDuration(plan.totalDuration)} • ${plan.totalDistanceKm.toStringAsFixed(1)} km',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PillButton(
                  icon: Icons.schedule,
                  label: 'Start ${_fmtTime(startTime)}',
                  onTap: onPickTime,
                  filled: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PillButton(
                  icon: Icons.map_outlined,
                  label: 'Open in Maps',
                  onTap: onOpenMaps,
                  filled: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    final bg = filled ? AppColors.accent : AppColors.surface;
    final fg = filled ? AppColors.primary : AppColors.accent;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: filled
                ? null
                : Border.all(
                    color: AppColors.accent.withValues(alpha: 0.4), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.labelLarge
                      .copyWith(color: fg, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}