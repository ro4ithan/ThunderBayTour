import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/tour_provider.dart';
import 'widgets/tour_summary_header.dart';
import 'widgets/tour_timeline_card.dart';
import 'widgets/travel_bubble.dart';
import 'widgets/tour_end_card.dart';
import 'widgets/empty_tour_view.dart';

class TourScreen extends ConsumerWidget {
  const TourScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tour = ref.watch(tourRouteProvider);

    if (tour.isEmpty) {
      return const Scaffold(body: SafeArea(child: EmptyTourView()));
    }

    final stops = tour.stops;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            TourSummaryHeader(tour: tour),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16, bottom: 100),
                itemCount: stops.length * 2 + 1, // stop + travel bubble + end
                itemBuilder: (context, index) {
                  if (index == stops.length * 2) {
                    return TourEndCard(tour: tour)
                        .animate()
                        .fadeIn(delay: (300 + stops.length * 200).ms);
                  }
                  if (index.isOdd) {
                    final stopIdx = index ~/ 2;
                    if (stopIdx + 1 >= stops.length) return const SizedBox();
                    final current = stops[stopIdx]; // ✅ use current stop
                    return TravelBubble(
                      minutes: current.travelTimeToNextMinutes,
                      mode: current.travelModeToNext,
                    ).animate().fadeIn(delay: (200 + stopIdx * 200 + 100).ms);
                  }
                  final stopIdx = index ~/ 2;
                  final stop = stops[stopIdx];
                  return TimelineTile(
                    alignment: TimelineAlign.start,
                    isFirst: stopIdx == 0,
                    isLast: false,
                    indicatorStyle: IndicatorStyle(
                      width: 36,
                      indicator: CircleAvatar(
                        backgroundColor: AppColors.accent,
                        child: Text(
                          '${stop.orderIndex}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    beforeLineStyle: const LineStyle(
                      color: AppColors.accent,
                      thickness: 2,
                    ),
                    endChild: Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 12),
                      child: TourTimelineCard(stop: stop),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: (200 + stopIdx * 200).ms)
                      .slideX(begin: 0.2, end: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
