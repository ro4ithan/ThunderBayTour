import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/models/tour_route.dart';
import '../../../providers/attractions_provider.dart';
import 'tour_start_time_widget.dart';

class TourSummaryHeader extends ConsumerWidget {
  final TourRoute tour;
  const TourSummaryHeader({super.key, required this.tour});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attractions = ref.watch(allAttractionsProvider);

    final hours = tour.totalMinutes ~/ 60;
    final mins = tour.totalMinutes % 60;
    final travelHours = tour.totalTravelMinutes ~/ 60;
    final travelMins = tour.totalTravelMinutes % 60;

    final avgRating = tour.stops.isEmpty
        ? 0.0
        : tour.stops
                .map((s) {
                  final a = attractions.firstWhere(
                    (x) => x.id == s.attractionId,
                    orElse: () => attractions.first,
                  );
                  return a.rating;
                })
                .reduce((a, b) => a + b) /
            tour.stops.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D1B2A), Color(0xFF1B4332)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Thunder Bay Tour',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${tour.stops.length} stops · ${hours}h ${mins}m total',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _stat('🕐', 'Visit Time', '${hours}h ${mins}m')),
              Expanded(
                  child: _stat('🚗', 'Travel',
                      travelHours > 0 ? '${travelHours}h ${travelMins}m' : '${travelMins}m')),
              Expanded(
                  child: _stat('⭐', 'Avg Rating', avgRating.toStringAsFixed(1))),
            ],
          ),
          const SizedBox(height: 20),
          TourStartTimeWidget(
            startTime: tour.startTime,
            endTime: tour.endTime,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _stat(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        Text(label,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6), fontSize: 11)),
      ],
    );
  }
}