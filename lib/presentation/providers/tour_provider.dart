import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/distance_utils.dart';
import '../../core/utils/season_utils.dart';
import '../../domain/models/attraction.dart';
import '../../domain/models/tour_route.dart';
import '../../domain/models/tour_stop.dart';
import 'attractions_provider.dart';
import 'saved_provider.dart';

final tourRouteProvider = Provider<TourRoute>((ref) {
  final saved = ref.watch(savedProvider);
  final all = ref.watch(attractionsProvider);

  if (saved.isEmpty) {
    return const TourRoute(
      stops: [],
      totalMinutes: 0,
      totalTravelMinutes: 0,
      startTime: '',
      endTime: '',
    );
  }

  // Get saved Attraction objects, preserving only those that exist
  final savedAttractions = <Attraction>[
    for (final s in saved)
      ...all.where((a) => a.id == s.attractionId),
  ];

  if (savedAttractions.isEmpty) {
    return const TourRoute(
      stops: [],
      totalMinutes: 0,
      totalTravelMinutes: 0,
      startTime: '',
      endTime: '',
    );
  }

  // ----- Greedy Nearest Neighbor from downtown -----
  double curLat = AppConstants.thunderBayDowntownLat;
  double curLng = AppConstants.thunderBayDowntownLng;
  final remaining = [...savedAttractions];
  final ordered = <Attraction>[];

  while (remaining.isNotEmpty) {
    remaining.sort((a, b) => DistanceUtils.haversineKm(curLat, curLng, a.latitude, a.longitude)
        .compareTo(DistanceUtils.haversineKm(curLat, curLng, b.latitude, b.longitude)));
    final next = remaining.removeAt(0);
    ordered.add(next);
    curLat = next.latitude;
    curLng = next.longitude;
  }

  // ----- Build TourStops with timing -----
  final stops = <TourStop>[];
  int totalVisit = 0;
  int totalTravel = 0;

  // Start time = best start computed below; for now build stops with cumulative offsets
  final season = SeasonUtils.getCurrentSeason();
  final sunset = SeasonUtils.getSunsetTime(season);

  // Compute total duration first to find best start time
  for (int i = 0; i < ordered.length; i++) {
    totalVisit += ordered[i].estimatedVisitMinutes;
    if (i < ordered.length - 1) {
      final km = DistanceUtils.haversineKm(
        ordered[i].latitude,
        ordered[i].longitude,
        ordered[i + 1].latitude,
        ordered[i + 1].longitude,
      );
      final roadKm = km * 1.4;
      final speed = roadKm > 5 ? 60.0 : 30.0;
      final mins = (roadKm / speed * 60).round();
      totalTravel += mins;
    }
  }

  // Best start: sunset - total - 30min buffer, rounded to nearest 30 min
  final totalMinutes = totalVisit + totalTravel + 30;
  DateTime startDt = sunset.subtract(Duration(minutes: totalMinutes));
  final roundedMin = (startDt.minute / 30).round() * 30;
  startDt = DateTime(startDt.year, startDt.month, startDt.day, startDt.hour)
      .add(Duration(minutes: roundedMin));

  // Build stops with real arrival/departure times
  DateTime cursor = startDt;
  for (int i = 0; i < ordered.length; i++) {
    final a = ordered[i];
    final arrive = cursor;
    final depart = arrive.add(Duration(minutes: a.estimatedVisitMinutes));

    int travelMins = 0;
    String mode = 'drive';
    if (i < ordered.length - 1) {
      final km = DistanceUtils.haversineKm(
        a.latitude,
        a.longitude,
        ordered[i + 1].latitude,
        ordered[i + 1].longitude,
      );
      final roadKm = km * 1.4;
      final speed = roadKm > 5 ? 60.0 : 30.0;
      travelMins = (roadKm / speed * 60).round();
      mode = roadKm > 2 ? 'drive' : 'walk';
    }

    stops.add(TourStop(
      attractionId: a.id,
      orderIndex: i,
      recommendedMinutes: a.estimatedVisitMinutes,
      travelTimeToNextMinutes: travelMins,
      travelModeToNext: mode,
      tip: a.bestTimeToVisit,
      suggestedArrivalTime: _fmt(arrive),
      suggestedDepartureTime: _fmt(depart),
    ));

    cursor = depart.add(Duration(minutes: travelMins));
  }

  return TourRoute(
    stops: stops,
    totalMinutes: totalVisit,
    totalTravelMinutes: totalTravel,
    startTime: _fmt(startDt),
    endTime: _fmt(cursor),
  );
});

String _fmt(DateTime dt) {
  final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
  final m = dt.minute.toString().padLeft(2, '0');
  final ampm = dt.hour >= 12 ? 'PM' : 'AM';
  return '$h:$m $ampm';
}