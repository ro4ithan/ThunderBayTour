import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/restaurants_repository.dart';
import '../../domain/models/restaurant.dart';

/// Repository singleton.
final restaurantsRepositoryProvider = Provider<RestaurantsRepository>((ref) {
  return RestaurantsRepository();
});

/// Currently-selected category filter. `null` = "All".
final selectedRestaurantCategoryProvider =
    StateProvider<RestaurantCategory?>((ref) => null);

/// All restaurants (full list).
final allRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  return ref.watch(restaurantsRepositoryProvider).getAll();
});

/// Filtered restaurants based on selected category.
final filteredRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  final all = ref.watch(allRestaurantsProvider);
  final selected = ref.watch(selectedRestaurantCategoryProvider);
  if (selected == null) return all;
  return all.where((r) => r.category == selected).toList();
});

/// Single restaurant lookup by id (for detail screen).
final restaurantByIdProvider =
    Provider.family<Restaurant?, String>((ref, id) {
  final repo = ref.watch(restaurantsRepositoryProvider);
  return repo.getById(id);
});