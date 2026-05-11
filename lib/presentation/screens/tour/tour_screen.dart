import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/maps_launcher.dart';
import '../../providers/saved_provider.dart';
import '../../providers/tour_planner_provider.dart';
import 'widgets/empty_tour_state.dart';
import 'widgets/missing_meals_banner.dart';
import 'widgets/tour_header.dart';
import 'widgets/tour_stop_card.dart';

class TourScreen extends ConsumerWidget {
  const TourScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(tourPlanProvider);
    final startTime = ref.watch(tourStartTimeProvider);

    if (plan.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: EmptyTourState(onBrowse: () => context.go('/home')),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: TourHeader(
                plan: plan,
                startTime: startTime,
                onPickTime: () => _pickStartTime(context, ref, startTime),
                onOpenMaps: () => MapsLauncher.openMultiStop(
                  context: context,
                  stops: plan.stops
                      .map((s) => (lat: s.latitude, lng: s.longitude))
                      .toList(),
                ),
                onClear: () => _confirmClear(context, ref),
              ),
            ),

            // Render each day as its own section
            for (var i = 0; i < plan.days.length; i++) ...[
              SliverToBoxAdapter(
                child: _DaySectionHeader(
                  day: plan.days[i],
                  isFirst: i == 0,
                ),
              ),
              if (plan.days[i].missingMeals.isNotEmpty)
                SliverToBoxAdapter(
                  child: MissingMealsBanner(
                    suggestions: plan.days[i].missingMeals,
                  ),
                ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  4,
                  16,
                  i == plan.days.length - 1 ? 120 : 8,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, indexInDay) {
                      final stop = plan.days[i].stops[indexInDay];
                      final globalIndex =
                          _globalIndex(plan, dayIdx: i, localIdx: indexInDay);
                      return TourStopCard(
                        key: ValueKey('stop_${stop.id}_${stop.type.name}'),
                        stop: stop,
                        index: globalIndex,
                        isLast: indexInDay == plan.days[i].stops.length - 1,
                        onRemove: () => ref
                            .read(savedProvider.notifier)
                            .removeFromTour(stop.id, stop.type),
                      )
                          .animate()
                          .fadeIn(delay: (indexInDay * 70).ms, duration: 300.ms)
                          .slideX(begin: 0.1, end: 0);
                    },
                    childCount: plan.days[i].stops.length,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Compute the global stop number across all days (1-based for badge).
  int _globalIndex(TourPlan plan,
      {required int dayIdx, required int localIdx}) {
    var count = 0;
    for (var i = 0; i < dayIdx; i++) {
      count += plan.days[i].stops.length;
    }
    return count + localIdx;
  }

  Future<void> _pickStartTime(
      BuildContext context, WidgetRef ref, DateTime current) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (picked == null) return;
    final now = DateTime.now();
    ref.read(tourStartTimeProvider.notifier).state =
        DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Clear Tour?'),
        content: const Text(
            'This removes all stops from your tour. Saved items remain saved.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Clear',
                style:
                    AppTextStyles.labelLarge.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(savedProvider.notifier).clearTour();
    }
  }
}

// ============================================================
// DAY SECTION HEADER
// ============================================================

class _DaySectionHeader extends StatelessWidget {
  const _DaySectionHeader({required this.day, required this.isFirst});
  final TourDay day;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final hours = day.totalDuration.inHours;
    final mins = day.totalDuration.inMinutes.remainder(60);
    final durLabel = hours > 0 ? '${hours}h ${mins}m' : '${mins}m';

    return Padding(
      padding: EdgeInsets.fromLTRB(16, isFirst ? 8 : 20, 16, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.accent.withValues(alpha: 0.18),
              AppColors.accent.withValues(alpha: 0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.dayNumber}',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day ${day.dayNumber}',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${day.stops.length} stops  •  $durLabel  •  ${day.totalDistanceKm.toStringAsFixed(1)} km',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 350.ms)
          .slideX(begin: -0.05, end: 0, curve: Curves.easeOutCubic),
    );
  }
}
