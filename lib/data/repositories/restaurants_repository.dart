import '../../domain/models/restaurant.dart';
import '../datasources/thunder_bay_data.dart';

class RestaurantsRepository {
  const RestaurantsRepository();

  List<Restaurant> getAll() => ThunderBayData.restaurants;

  List<Restaurant> getLocalFavorites() => ThunderBayData.restaurants
      .where((r) => r.isLocalFavorite)
      .toList(growable: false);

  Restaurant? getById(String id) {
    try {
      return ThunderBayData.restaurants.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}