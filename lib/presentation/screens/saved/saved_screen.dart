import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/enums/saved_item_type.dart';
import '../../../core/utils/distance_utils.dart';
import '../../../domain/models/attraction.dart';
import '../../../domain/models/restaurant.dart';
import '../../providers/attractions_provider.dart';
import '../../providers/restaurants_provider.dart';
import '../../providers/saved_provider.dart';
import 'widgets/empty_saved_state.dart';
import 'widgets/saved_attraction_tile.dart';
import 'widgets/saved_restaurant_tile.dart';
import 'widgets/sort_selector.dart';

enum SortOption { recentlyAdded, rating, distance }

final sortProvider = StateProvider<SortOption>((_) => SortOption.recentlyAdded);
final savedTabProvider = StateProvider<SavedItemType>((_) => SavedItemType.attraction);

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedProvider);
    final attractions = ref.watch(allAttractionsProvider);
    final restaurants = ref.watch(allRestaurantsProvider);
    final sort = ref.watch(sortProvider);
    final tab = ref.watch(savedTabProvider);

    if (saved.isEmpty) {
      return const Scaffold(body: SafeArea(child: EmptySavedState()));
    }

    final attractionCount =
        saved.where((s) => s.type == SavedItemType.attraction).length;
    final restaurantCount =
        saved.where((s) => s.type == SavedItemType.restaurant).length;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Saved Places',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                      '$attractionCount attractions • $restaurantCount restaurants',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65))),
                  const SizedBox(height: 12),
                  _SegmentedTabs(
                    current: tab,
                    attractionCount: attractionCount,
                    restaurantCount: restaurantCount,
                    onChanged: (t) =>
                        ref.read(savedTabProvider.notifier).state = t,
                  ),
                  const SizedBox(height: 12),
                  const SortSelector(),
                ],
              ),
            ),
            Expanded(
              child: tab == SavedItemType.attraction
                  ? _AttractionsList(
                      saved: saved, attractions: attractions, sort: sort)
                  : _RestaurantsList(
                      saved: saved, restaurants: restaurants, sort: sort),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final SavedItemType current;
  final int attractionCount;
  final int restaurantCount;
  final ValueChanged<SavedItemType> onChanged;

  const _SegmentedTabs({
    required this.current,
    required this.attractionCount,
    required this.restaurantCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tab('Attractions ($attractionCount)', SavedItemType.attraction),
          _tab('Restaurants ($restaurantCount)', SavedItemType.restaurant),
        ],
      ),
    );
  }

  Widget _tab(String label, SavedItemType type) {
    final selected = current == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.amber : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.black : Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _AttractionsList extends StatelessWidget {
  final List saved;
  final List<Attraction> attractions;
  final SortOption sort;
  const _AttractionsList(
      {required this.saved, required this.attractions, required this.sort});

  @override
  Widget build(BuildContext context) {
    final pairs = saved
        .where((s) => s.type == SavedItemType.attraction)
        .map<MapEntry<dynamic, Attraction>?>((s) {
          try {
            final a = attractions.firstWhere((x) => x.id == s.id);
            return MapEntry(s, a);
          } catch (_) {
            return null;
          }
        })
        .whereType<MapEntry<dynamic, Attraction>>()
        .toList();

    _sortPairs(pairs, sort, (a) => a.latitude, (a) => a.longitude, (a) => a.rating);

    if (pairs.isEmpty) {
      return const Center(child: Text('No saved attractions yet'));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: pairs.length,
      itemBuilder: (_, i) {
        final p = pairs[i];
        return SavedAttractionTile(
                savedAt: p.key.savedAt, attraction: p.value)
            .animate()
            .fadeIn(delay: (i * 60).ms, duration: 280.ms)
            .slideY(begin: 0.12, end: 0);
      },
    );
  }
}

class _RestaurantsList extends StatelessWidget {
  final List saved;
  final List<Restaurant> restaurants;
  final SortOption sort;
  const _RestaurantsList(
      {required this.saved, required this.restaurants, required this.sort});

  @override
  Widget build(BuildContext context) {
    final pairs = saved
        .where((s) => s.type == SavedItemType.restaurant)
        .map<MapEntry<dynamic, Restaurant>?>((s) {
          try {
            final r = restaurants.firstWhere((x) => x.id == s.id);
            return MapEntry(s, r);
          } catch (_) {
            return null;
          }
        })
        .whereType<MapEntry<dynamic, Restaurant>>()
        .toList();

    _sortPairs(pairs, sort, (r) => r.latitude, (r) => r.longitude, (r) => r.rating);

    if (pairs.isEmpty) {
      return const Center(child: Text('No saved restaurants yet'));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: pairs.length,
      itemBuilder: (_, i) {
        final p = pairs[i];
        return SavedRestaurantTile(
                savedAt: p.key.savedAt, restaurant: p.value)
            .animate()
            .fadeIn(delay: (i * 60).ms, duration: 280.ms)
            .slideY(begin: 0.12, end: 0);
      },
    );
  }
}

void _sortPairs<T>(
  List<MapEntry<dynamic, T>> pairs,
  SortOption sort,
  double Function(T) latOf,
  double Function(T) lngOf,
  double Function(T) ratingOf,
) {
  switch (sort) {
    case SortOption.recentlyAdded:
      pairs.sort((a, b) => b.key.savedAt.compareTo(a.key.savedAt));
      break;
    case SortOption.rating:
      pairs.sort((a, b) => ratingOf(b.value).compareTo(ratingOf(a.value)));
      break;
    case SortOption.distance:
      pairs.sort((a, b) {
        final da = DistanceUtils.haversineKm(
            AppConstants.thunderBayDowntownLat,
            AppConstants.thunderBayDowntownLng,
            latOf(a.value),
            lngOf(a.value));
        final db = DistanceUtils.haversineKm(
            AppConstants.thunderBayDowntownLat,
            AppConstants.thunderBayDowntownLng,
            latOf(b.value),
            lngOf(b.value));
        return da.compareTo(db);
      });
      break;
  }
}