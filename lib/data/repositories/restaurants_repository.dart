import '../../domain/models/restaurant.dart';
import '../datasources/thunder_bay_data.dart';

class RestaurantsRepository {
  RestaurantsRepository();

  /// All restaurants in Thunder Bay.
  List<Restaurant> getAll() => ThunderBayData.restaurants;

  /// Lookup a restaurant by id. Returns null if not found.
  Restaurant? getById(String id) {
    try {
      return ThunderBayData.restaurants.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Filter by category.
  List<Restaurant> getByCategory(RestaurantCategory category) =>
      ThunderBayData.restaurants
          .where((r) => r.category == category)
          .toList();

  /// Local favourites only (curated picks).
  List<Restaurant> getLocalFavourites() =>
      ThunderBayData.restaurants.where((r) => r.isLocalFavorite).toList();

  /// Top-rated, sorted descending by rating. Capped at [limit].
  List<Restaurant> getTopRated({int limit = 5}) {
    final sorted = [...ThunderBayData.restaurants]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(limit).toList();
  }
}