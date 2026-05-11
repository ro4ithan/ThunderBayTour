import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/enums/saved_item_type.dart';
import '../../data/datasources/thunder_bay_data.dart';
import '../../data/repositories/saved_repository.dart';
import '../../domain/models/saved_item.dart';

/// Provider for SavedNotifier. Overridden in main.dart with the SharedPreferences instance.
final savedProvider =
    StateNotifierProvider<SavedNotifier, List<SavedItem>>((ref) {
  throw UnimplementedError('Must override savedProvider with prefs in main()');
});

class SavedNotifier extends StateNotifier<List<SavedItem>> {
  final SavedRepository _repo;

  SavedNotifier(SharedPreferences prefs)
      : _repo = SavedRepository(prefs),
        super(const []) {
    state = _repo.getAll();
  }

  // ---------------- SAVE / UNSAVE ----------------

  bool isSaved(String id, SavedItemType type) =>
      state.any((e) => e.id == id && e.type == type);

  Future<void> toggleSave(String id, SavedItemType type) async {
    final existing = state.where((e) => e.id == id && e.type == type);
    if (existing.isNotEmpty) {
      state = state.where((e) => !(e.id == id && e.type == type)).toList();
    } else {
      state = [
        ...state,
        SavedItem(id: id, type: type, savedAt: DateTime.now()),
      ];
    }
    await _repo.saveAll(state);
  }

  // ---------------- TOUR MANAGEMENT ----------------

  List<SavedItem> get tourItems {
    final items = state.where((e) => e.inTour).toList()
      ..sort((a, b) => (a.tourOrder ?? 0).compareTo(b.tourOrder ?? 0));
    return items;
  }

  bool isInTour(String id, SavedItemType type) =>
      state.any((e) => e.id == id && e.type == type && e.inTour);

  Future<void> addToTour(String id, SavedItemType type) async {
    final existing = state.where((e) => e.id == id && e.type == type);

    if (existing.isEmpty) {
      state = [
        ...state,
        SavedItem(
          id: id,
          type: type,
          savedAt: DateTime.now(),
          inTour: true,
          tourOrder: tourItems.length,
        ),
      ];
    } else {
      state = state
          .map((e) => (e.id == id && e.type == type)
              ? e.copyWith(inTour: true, tourOrder: tourItems.length)
              : e)
          .toList();
    }
    await _optimizeAndPersist();
  }

  Future<void> removeFromTour(String id, SavedItemType type) async {
    state = state
        .map((e) => (e.id == id && e.type == type)
            ? e.copyWith(inTour: false, tourOrder: null)
            : e)
        .toList();
    await _optimizeAndPersist();
  }

  Future<void> reorderTour(int oldIndex, int newIndex) async {
    final items = tourItems;
    if (oldIndex < 0 || oldIndex >= items.length) return;
    if (newIndex > items.length) newIndex = items.length;
    if (newIndex > oldIndex) newIndex -= 1;

    final moved = items.removeAt(oldIndex);
    items.insert(newIndex, moved);

    final orderMap = {
      for (var i = 0; i < items.length; i++)
        items[i].id + items[i].type.name: i
    };

    state = state.map((e) {
      final key = e.id + e.type.name;
      if (orderMap.containsKey(key)) {
        return e.copyWith(inTour: true, tourOrder: orderMap[key]);
      }
      return e;
    }).toList();

    // Note: do NOT re-optimize after a manual drag — respect user intent.
    await _repo.saveAll(state);
  }

  Future<void> clearTour() async {
    state = state
        .map((e) => e.inTour ? e.copyWith(inTour: false, tourOrder: null) : e)
        .toList();
    await _repo.saveAll(state);
  }

  /// Public hook in case you want to add an "✨ Optimize" button later.
  Future<void> optimizeTour() => _optimizeAndPersist();

  // ---------------- SMART OPTIMIZER ----------------

  Future<void> _optimizeAndPersist() async {
    final items = state.where((e) => e.inTour).toList();
    if (items.isEmpty) {
      await _repo.saveAll(state);
      return;
    }

    final optimized = _smartReorder(items);

    final orderMap = {
      for (var i = 0; i < optimized.length; i++)
        optimized[i].id + optimized[i].type.name: i
    };

    state = state.map((e) {
      final key = e.id + e.type.name;
      if (orderMap.containsKey(key)) {
        return e.copyWith(inTour: true, tourOrder: orderMap[key]);
      }
      return e;
    }).toList();

    await _repo.saveAll(state);
  }

  /// Smart reorder:
  /// 1. Separate restaurants by meal slot (breakfast/lunch/dinner)
  /// 2. Nearest-neighbor sort attractions starting from downtown TBay
  /// 3. Insert restaurants at the correct meal-time index based on
  ///    cumulative visit + travel time.
  List<SavedItem> _smartReorder(List<SavedItem> items) {
    final attractionItems = <SavedItem>[];
    final breakfast = <SavedItem>[];
    final lunch = <SavedItem>[];
    final dinner = <SavedItem>[];

    for (final it in items) {
      if (it.type == SavedItemType.attraction) {
        attractionItems.add(it);
        continue;
      }
      final r = ThunderBayData.restaurants
          .where((x) => x.id == it.id)
          .firstOrNull;
      if (r == null) continue;
      final slot = _classifyRestaurant(r.name, r.cuisine);
      if (slot == 'breakfast') {
        breakfast.add(it);
      } else if (slot == 'dinner') {
        dinner.add(it);
      } else {
        lunch.add(it);
      }
    }

    // 1) Nearest-neighbor sort attractions from downtown TBay anchor
    final orderedAttractions = _nearestNeighbor(
      attractionItems,
      startLat: AppConstants.thunderBayDowntownLat,
      startLng: AppConstants.thunderBayDowntownLng,
    );

    // 2) Build timeline-aware insertion of restaurants.
    // Assume start time 9:00 AM, avg 50 km/h, attractions = 90 min default stay,
    // restaurants = 60 min stay.
    final result = <SavedItem>[];
    DateTime cursor =
        DateTime(2026, 1, 1, 9, 0); // arbitrary same-day reference
    double? prevLat;
    double? prevLng;

    // Queues so we pop in order:
    final bQueue = List<SavedItem>.from(breakfast);
    final lQueue = List<SavedItem>.from(lunch);
    final dQueue = List<SavedItem>.from(dinner);

    bool placedLunch = false;
    bool placedDinner = false;

    void placeStop(SavedItem item) {
      final coords = _coordsFor(item);
      if (coords == null) return;

      if (prevLat != null && prevLng != null) {
        final km =
            _haversineKm(prevLat!, prevLng!, coords.$1, coords.$2);
        cursor = cursor.add(Duration(minutes: ((km / 50.0) * 60).round()));
      }
      result.add(item);
      cursor = cursor.add(Duration(minutes: _stayMinutes(item)));
      prevLat = coords.$1;
      prevLng = coords.$2;
    }

    // Place breakfast first if we have one (before any attraction)
    if (bQueue.isNotEmpty) {
      placeStop(bQueue.removeAt(0));
    }

    for (final att in orderedAttractions) {
      // Before placing each attraction, check if we should slot in lunch/dinner.
      if (!placedLunch && cursor.hour >= 12 && lQueue.isNotEmpty) {
        placeStop(lQueue.removeAt(0));
        placedLunch = true;
      }
      if (!placedDinner && cursor.hour >= 18 && dQueue.isNotEmpty) {
        placeStop(dQueue.removeAt(0));
        placedDinner = true;
      }
      placeStop(att);
    }

    // Append any leftover meals at the end (in order)
    for (final r in [...bQueue, ...lQueue, ...dQueue]) {
      placeStop(r);
    }

    return result;
  }

  // ---------------- HELPERS ----------------

  String _classifyRestaurant(String name, String cuisine) {
    final lower = '$name $cuisine'.toLowerCase();
    if (lower.contains('breakfast') ||
        lower.contains('brunch') ||
        lower.contains('cafe') ||
        lower.contains('coffee') ||
        lower.contains('bakery') ||
        lower.contains('diner')) {
      return 'breakfast';
    }
    if (lower.contains('fine dining') ||
        lower.contains('steakhouse') ||
        lower.contains('wine') ||
        lower.contains('bistro') ||
        lower.contains('tavern') ||
        lower.contains('pub')) {
      return 'dinner';
    }
    return 'lunch';
  }

  int _stayMinutes(SavedItem item) {
    if (item.type == SavedItemType.restaurant) return 60;
    final a = ThunderBayData.attractions
        .where((x) => x.id == item.id)
        .firstOrNull;
    return a?.estimatedVisitMinutes ?? 90;
  }

  (double, double)? _coordsFor(SavedItem item) {
    if (item.type == SavedItemType.attraction) {
      final a = ThunderBayData.attractions
          .where((x) => x.id == item.id)
          .firstOrNull;
      if (a == null) return null;
      return (a.latitude, a.longitude);
    } else {
      final r = ThunderBayData.restaurants
          .where((x) => x.id == item.id)
          .firstOrNull;
      if (r == null) return null;
      return (r.latitude, r.longitude);
    }
  }

  List<SavedItem> _nearestNeighbor(
    List<SavedItem> items, {
    required double startLat,
    required double startLng,
  }) {
    if (items.isEmpty) return [];
    final remaining = List<SavedItem>.from(items);
    final ordered = <SavedItem>[];
    double curLat = startLat;
    double curLng = startLng;

    while (remaining.isNotEmpty) {
      SavedItem? best;
      double bestDist = double.infinity;
      for (final it in remaining) {
        final c = _coordsFor(it);
        if (c == null) continue;
        final d = _haversineKm(curLat, curLng, c.$1, c.$2);
        if (d < bestDist) {
          bestDist = d;
          best = it;
        }
      }
      if (best == null) break;
      ordered.add(best);
      remaining.remove(best);
      final c = _coordsFor(best)!;
      curLat = c.$1;
      curLng = c.$2;
    }
    return ordered;
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
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}

final savedCountProvider = Provider<int>((ref) {
  return ref.watch(savedProvider).length;
});

final tourCountProvider = Provider<int>((ref) {
  return ref.watch(savedProvider).where((e) => e.inTour).length;
});