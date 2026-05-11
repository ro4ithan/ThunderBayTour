import '../../core/enums/meal_slot.dart';
import '../../core/enums/saved_item_type.dart';
import 'attraction.dart';
import 'restaurant.dart';

/// A computed stop on the tour timeline.
/// Holds either an attraction or a restaurant plus arrival/departure times.
class TourStop {
  final SavedItemType type;
  final Attraction? attraction;
  final Restaurant? restaurant;

  /// Distance (km) from previous stop. 0 for the first stop.
  final double distanceFromPrevKm;

  /// Travel duration from previous stop.
  final Duration travelDuration;

  /// Computed arrival time at this stop.
  final DateTime arrivalTime;

  /// Time the user spends here (visit duration or 60 min for restaurants).
  final Duration stayDuration;

  /// Meal slot label — only meaningful for restaurants.
  final MealSlot mealSlot;

  const TourStop({
    required this.type,
    this.attraction,
    this.restaurant,
    required this.distanceFromPrevKm,
    required this.travelDuration,
    required this.arrivalTime,
    required this.stayDuration,
    this.mealSlot = MealSlot.none,
  });

  String get id =>
      type == SavedItemType.attraction ? attraction!.id : restaurant!.id;

  String get name =>
      type == SavedItemType.attraction ? attraction!.name : restaurant!.name;

  String get imageUrl => type == SavedItemType.attraction
      ? attraction!.imageUrl
      : restaurant!.imageUrl;

  double get latitude => type == SavedItemType.attraction
      ? attraction!.latitude
      : restaurant!.latitude;

  double get longitude => type == SavedItemType.attraction
      ? attraction!.longitude
      : restaurant!.longitude;

  DateTime get departureTime => arrivalTime.add(stayDuration);
}

/// A "missing meal" suggestion shown in the tour banner when no restaurant
/// is added for a meal window the tour overlaps with.
class MealSuggestion {
  final MealSlot slot;
  final DateTime approximateTime;

  const MealSuggestion({
    required this.slot,
    required this.approximateTime,
  });
}