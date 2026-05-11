import 'tour_day.dart';
import 'tour_stop.dart';

/// A complete multi-day tour itinerary.
class TourRoute {
  final List<TourDay> days;

  const TourRoute({required this.days});

  /// Flat list of all stops across all days (useful for backward compat).
  List<TourStop> get allStops =>
      days.expand((d) => d.stops).toList(growable: false);

  int get totalStops => allStops.length;
  int get dayCount => days.length;

  Duration get totalDuration => days.fold(
        Duration.zero,
        (sum, d) => sum + d.totalDuration,
      );

  double get totalDistanceKm =>
      days.fold(0.0, (sum, d) => sum + d.totalDistanceKm);

  bool get isEmpty => days.isEmpty || allStops.isEmpty;

  static const TourRoute empty = TourRoute(days: []);
}