import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums/category.dart';
import '../../core/utils/attraction_scorer.dart';
import '../../data/repositories/attractions_repository.dart';
import '../../domain/models/attraction.dart';
import 'date_context_provider.dart';
import 'weather_provider.dart';

final attractionsRepositoryProvider =
    Provider<AttractionsRepository>((_) => const AttractionsRepository());

final allAttractionsProvider = Provider<List<Attraction>>(
  (ref) => ref.watch(attractionsRepositoryProvider).getAll(),
);

final featuredAttractionsProvider = Provider<List<Attraction>>(
  (ref) => ref.watch(attractionsRepositoryProvider).getFeatured(limit: 5),
);

/// Selected category filter (null = All).
final categoryFilterProvider = StateProvider<AttractionCategory?>((_) => null);

/// Selected season activity filter (null = none).
final activityFilterProvider = StateProvider<String?>((_) => null);

/// Filtered attractions list driving the grid — now weather/season scored & sorted.
final filteredAttractionsProvider = Provider<List<Attraction>>((ref) {
  final all = ref.watch(allAttractionsProvider);
  final category = ref.watch(categoryFilterProvider);
  final activity = ref.watch(activityFilterProvider);
  final dateCtx = ref.watch(dateContextProvider);
  final weather = ref.watch(weatherProvider).asData?.value;

  final filtered = all.where((a) {
    if (category != null && a.category != category) return false;
    if (activity != null &&
        !a.activities.any(
          (act) => act.toLowerCase().contains(activity.toLowerCase()),
        )) {
      return false;
    }
    return true;
  }).toList();

  // Sort by today's fit score (descending)
  filtered.sort((a, b) {
    final sa =
        AttractionScorer.score(a, weather, dateCtx.season).score;
    final sb =
        AttractionScorer.score(b, weather, dateCtx.season).score;
    return sb.compareTo(sa);
  });

  return List.unmodifiable(filtered);
});

/// Score for a single attraction (used by cards for badges).
final attractionScoreProvider =
    Provider.family<AttractionScore, Attraction>((ref, attraction) {
  final dateCtx = ref.watch(dateContextProvider);
  final weather = ref.watch(weatherProvider).asData?.value;
  return AttractionScorer.score(attraction, weather, dateCtx.season);
});

/// Alias kept for backwards compatibility.
final attractionsProvider = allAttractionsProvider;