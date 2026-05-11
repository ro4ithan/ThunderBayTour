import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums/meal_slot.dart';
import '../../core/enums/saved_item_type.dart';
import '../../data/repositories/attractions_repository.dart';
import '../../data/repositories/restaurants_repository.dart';
import '../../domain/models/attraction.dart';
import '../../domain/models/restaurant.dart';
import '../../domain/models/saved_item.dart';
import '../../domain/models/tour_stop.dart';
import 'attractions_provider.dart';
import 'restaurants_provider.dart';
import 'saved_provider.dart';

/// User-selected start time for the tour (default 9:00 AM today).
final tourStartTimeProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 9, 0);
});

const _avgSpeedKmH = 50.0;
const _restaurantStayMinutes = 60;

/// Daily budget: hard cap on activity hours per day (9 AM → 7 PM = 10h).
const _dailyBudgetMinutes = 10 * 60;

// ============================================================
// MODELS
// ============================================================

/// A single day of the multi-day tour itinerary.
class TourDay {
  final int dayNumber; // 1-indexed
  final List<TourStop> stops;
  final List<MealSuggestion> missingMeals;
  final Duration totalDuration;
  final double totalDistanceKm;
  final DateTime startTime;

  const TourDay({
    required this.dayNumber,
    required this.stops,
    required this.missingMeals,
    required this.totalDuration,
    required this.totalDistanceKm,
    required this.startTime,
  });

  bool get isEmpty => stops.isEmpty;
  DateTime get endTime =>
      stops.isEmpty ? startTime : stops.last.departureTime;
}

/// Full multi-day plan.
class TourPlan {
  final List<TourDay> days;

  const TourPlan({required this.days});

  bool get isEmpty => days.isEmpty || days.every((d) => d.isEmpty);

  int get totalStops =>
      days.fold(0, (sum, d) => sum + d.stops.length);

  Duration get totalDuration =>
      days.fold(Duration.zero, (sum, d) => sum + d.totalDuration);

  double get totalDistanceKm =>
      days.fold(0.0, (sum, d) => sum + d.totalDistanceKm);

  /// Flat list of all stops (useful for "Open in Maps" multi-stop link).
  List<TourStop> get stops =>
      days.expand((d) => d.stops).toList(growable: false);

  /// Flat aggregated missing meals across all days (legacy compat).
  List<MealSuggestion> get missingMeals =>
      days.expand((d) => d.missingMeals).toList(growable: false);

  static const TourPlan empty = TourPlan(days: []);
}

// ============================================================
// PROVIDER
// ============================================================

final tourPlanProvider = Provider<TourPlan>((ref) {
  final saved = ref.watch(savedProvider);
  final startTime = ref.watch(tourStartTimeProvider);
  final attractionsRepo = ref.watch(attractionsRepositoryProvider);
  final restaurantsRepo = ref.watch(restaurantsRepositoryProvider);

  final tourItems = saved.where((e) => e.inTour).toList()
    ..sort((a, b) => (a.tourOrder ?? 0).compareTo(b.tourOrder ?? 0));

  if (tourItems.isEmpty) return TourPlan.empty;

  // Build a flat resolved list first
  final resolved = <_ResolvedItem>[];
  for (final item in tourItems) {
    final r = _resolveStop(
      item: item,
      attractionsRepo: attractionsRepo,
      restaurantsRepo: restaurantsRepo,
    );
    if (r != null) resolved.add(r);
  }
  if (resolved.isEmpty) return TourPlan.empty;

  // ---- SPLIT INTO DAY BUCKETS ----
  final dayBuckets = <List<_ResolvedItem>>[];
  var currentBucket = <_ResolvedItem>[];
  var bucketMinutes = 0;

  for (final r in resolved) {
    final stopMin = r.stayDuration.inMinutes;
    // Rough travel estimate: assume 15 min between stops for budget check
    const roughTravelMin = 15;
    final wouldBe = bucketMinutes + stopMin + roughTravelMin;

    if (wouldBe > _dailyBudgetMinutes && currentBucket.isNotEmpty) {
      dayBuckets.add(currentBucket);
      currentBucket = <_ResolvedItem>[];
      bucketMinutes = 0;
    }
    currentBucket.add(r);
    bucketMinutes += stopMin + roughTravelMin;
  }
  if (currentBucket.isNotEmpty) dayBuckets.add(currentBucket);

  // ---- BUILD EACH DAY ----
  final days = <TourDay>[];
  for (var i = 0; i < dayBuckets.length; i++) {
    final dayStart = DateTime(
      startTime.year,
      startTime.month,
      startTime.day + i,
      startTime.hour,
      startTime.minute,
    );
    days.add(_buildDay(
      dayNumber: i + 1,
      dayStart: dayStart,
      items: dayBuckets[i],
    ));
  }

  return TourPlan(days: days);
});

/// Backwards-compatible legacy provider returning only Day 1 stops.
/// Kept in case other widgets still depend on the flat list.
final firstDayStopsProvider = Provider<List<TourStop>>((ref) {
  final plan = ref.watch(tourPlanProvider);
  return plan.days.isEmpty ? const [] : plan.days.first.stops;
});

// ============================================================
// DAY BUILDER
// ============================================================

TourDay _buildDay({
  required int dayNumber,
  required DateTime dayStart,
  required List<_ResolvedItem> items,
}) {
  final stops = <TourStop>[];
  DateTime currentTime = dayStart;
  double totalKm = 0;
  double? prevLat;
  double? prevLng;

  for (final r in items) {
    double distKm = 0;
    Duration travel = Duration.zero;
    if (prevLat != null && prevLng != null) {
      distKm = _haversineKm(prevLat, prevLng, r.lat, r.lng);
      travel = Duration(minutes: ((distKm / _avgSpeedKmH) * 60).round());
      currentTime = currentTime.add(travel);
    }
    totalKm += distKm;

    MealSlot mealSlot = MealSlot.none;
    if (r.savedItem.type == SavedItemType.restaurant) {
      mealSlot = MealSlot.fromHour(currentTime.hour);
    }

    stops.add(TourStop(
      type: r.savedItem.type,
      attraction: r.attraction,
      restaurant: r.restaurant,
      distanceFromPrevKm: distKm,
      travelDuration: travel,
      arrivalTime: currentTime,
      stayDuration: r.stayDuration,
      mealSlot: mealSlot,
    ));

    currentTime = currentTime.add(r.stayDuration);
    prevLat = r.lat;
    prevLng = r.lng;
  }

  final missingMeals = _computeMissingMeals(stops, dayStart);
  final totalDuration = stops.isEmpty
      ? Duration.zero
      : stops.last.departureTime.difference(dayStart);

  return TourDay(
    dayNumber: dayNumber,
    stops: stops,
    missingMeals: missingMeals,
    totalDuration: totalDuration,
    totalDistanceKm: totalKm,
    startTime: dayStart,
  );
}

// ============================================================
// HELPERS
// ============================================================

class _ResolvedItem {
  final SavedItem savedItem;
  final double lat;
  final double lng;
  final Duration stayDuration;
  final Attraction? attraction;
  final Restaurant? restaurant;
  _ResolvedItem({
    required this.savedItem,
    required this.lat,
    required this.lng,
    required this.stayDuration,
    this.attraction,
    this.restaurant,
  });
}

_ResolvedItem? _resolveStop({
  required SavedItem item,
  required AttractionsRepository attractionsRepo,
  required RestaurantsRepository restaurantsRepo,
}) {
  if (item.type == SavedItemType.attraction) {
    final a = attractionsRepo.getById(item.id);
    if (a == null) return null;
    return _ResolvedItem(
      savedItem: item,
      lat: a.latitude,
      lng: a.longitude,
      stayDuration: Duration(minutes: a.estimatedVisitMinutes),
      attraction: a,
    );
  } else {
    final r = restaurantsRepo.getById(item.id);
    if (r == null) return null;
    return _ResolvedItem(
      savedItem: item,
      lat: r.latitude,
      lng: r.longitude,
      stayDuration: const Duration(minutes: _restaurantStayMinutes),
      restaurant: r,
    );
  }
}

List<MealSuggestion> _computeMissingMeals(
    List<TourStop> stops, DateTime dayStart) {
  if (stops.isEmpty) return const [];

  final start = stops.first.arrivalTime;
  final end = stops.last.departureTime;

  final anchors = <MealSlot, int>{
    MealSlot.breakfast: 8,
    MealSlot.lunch: 12,
    MealSlot.snack: 16,
    MealSlot.dinner: 19,
  };

  final coveredSlots = stops
      .where((s) => s.type == SavedItemType.restaurant)
      .map((s) => s.mealSlot)
      .toSet();

  final missing = <MealSuggestion>[];
  for (final entry in anchors.entries) {
    if (coveredSlots.contains(entry.key)) continue;
    final anchor =
        DateTime(dayStart.year, dayStart.month, dayStart.day, entry.value);
    if (anchor.isAfter(start) && anchor.isBefore(end)) {
      missing.add(MealSuggestion(slot: entry.key, approximateTime: anchor));
    }
  }
  return missing;
}

double _haversineKm(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  final dLat = _deg2rad(lat2 - lat1);
  final dLng = _deg2rad(lng2 - lng1);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_deg2rad(lat1)) *
          math.cos(_deg2rad(lat2)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return r * c;
}

double _deg2rad(double deg) => deg * (math.pi / 180.0);