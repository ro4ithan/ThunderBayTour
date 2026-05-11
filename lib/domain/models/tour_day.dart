import 'tour_stop.dart';

/// A single day of a multi-day tour itinerary.
/// Each day has its own ordered list of stops, totals, and meal coverage flags.
class TourDay {
  final int dayNumber; // 1-indexed (Day 1, Day 2, ...)
  final List<TourStop> stops;
  final Duration totalDuration;     // visit + travel for the day
  final double totalDistanceKm;     // travel distance for the day
  final bool hasBreakfast;
  final bool hasLunch;
  final bool hasDinner;

  const TourDay({
    required this.dayNumber,
    required this.stops,
    required this.totalDuration,
    required this.totalDistanceKm,
    required this.hasBreakfast,
    required this.hasLunch,
    required this.hasDinner,
  });

  bool get isEmpty => stops.isEmpty;
  int get stopCount => stops.length;

  /// List of missing meal labels for this day, e.g. ['Lunch', 'Dinner'].
  List<String> get missingMeals => [
        if (!hasBreakfast) 'Breakfast',
        if (!hasLunch) 'Lunch',
        if (!hasDinner) 'Dinner',
      ];
}