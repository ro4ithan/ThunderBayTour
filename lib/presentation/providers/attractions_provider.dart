import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums/category.dart';
import '../../data/repositories/attractions_repository.dart';
import '../../data/repositories/restaurants_repository.dart';
import '../../domain/models/attraction.dart';
import '../../domain/models/restaurant.dart';

final attractionsRepositoryProvider =
    Provider<AttractionsRepository>((_) => const AttractionsRepository());

final restaurantsRepositoryProvider =
    Provider<RestaurantsRepository>((_) => const RestaurantsRepository());

final allAttractionsProvider = Provider<List<Attraction>>(
  (ref) => ref.watch(attractionsRepositoryProvider).getAll(),
);

final featuredAttractionsProvider = Provider<List<Attraction>>(
  (ref) => ref.watch(attractionsRepositoryProvider).getFeatured(limit: 5),
);

final restaurantsProvider = Provider<List<Restaurant>>(
  (ref) => ref.watch(restaurantsRepositoryProvider).getAll(),
);

/// Selected category filter (null = All).
final categoryFilterProvider = StateProvider<AttractionCategory?>((_) => null);

/// Selected season activity filter (null = none).
final activityFilterProvider = StateProvider<String?>((_) => null);

/// Filtered attractions list driving the grid.
final filteredAttractionsProvider = Provider<List<Attraction>>((ref) {
  final all = ref.watch(allAttractionsProvider);
  final category = ref.watch(categoryFilterProvider);
  final activity = ref.watch(activityFilterProvider);

  return all.where((a) {
    if (category != null && a.category != category) return false;
    if (activity != null &&
        !a.activities.any(
          (act) => act.toLowerCase().contains(activity.toLowerCase()),
        )) {
      return false;
    }
    return true;
  }).toList(growable: false);
});

/// Alias kept for backwards compatibility with files expecting `attractionsProvider`.
final attractionsProvider = allAttractionsProvider;