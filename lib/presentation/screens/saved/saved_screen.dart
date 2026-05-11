import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/distance_utils.dart';
import '../../../domain/models/attraction.dart';
import '../../providers/attractions_provider.dart';
import '../../providers/saved_provider.dart';
import '../../providers/sort_provider.dart';
import 'widgets/empty_saved_state.dart';
import 'widgets/saved_attraction_tile.dart';
import 'widgets/sort_selector.dart';

class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedProvider);
    final attractions = ref.watch(attractionsProvider);
    final sort = ref.watch(sortProvider);

    if (saved.isEmpty) {
      return const Scaffold(body: SafeArea(child: EmptySavedState()));
    }

    // Pair saved items with attractions
    final pairs = saved
        .map((s) {
          try {
            final a = attractions.firstWhere((x) => x.id == s.attractionId);
            return MapEntry(s, a);
          } catch (_) {
            return null;
          }
        })
        .whereType<MapEntry<dynamic, Attraction>>()
        .toList();

    // Sort
    switch (sort) {
      case SortOption.recentlyAdded:
        pairs.sort((a, b) => b.key.savedAt.compareTo(a.key.savedAt));
        break;
      case SortOption.rating:
        pairs.sort((a, b) => b.value.rating.compareTo(a.value.rating));
        break;
      case SortOption.distance:
        pairs.sort((a, b) {
          final da = DistanceUtils.haversineKm(
              AppConstants.thunderBayDowntownLat,
              AppConstants.thunderBayDowntownLng,
              a.value.latitude,
              a.value.longitude);
          final db = DistanceUtils.haversineKm(
              AppConstants.thunderBayDowntownLat,
              AppConstants.thunderBayDowntownLng,
              b.value.latitude,
              b.value.longitude);
          return da.compareTo(db);
        });
        break;
    }

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
                  Text('${saved.length} places saved',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65))),
                  const SizedBox(height: 12),
                  const SortSelector(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                itemCount: pairs.length,
                itemBuilder: (_, i) {
                  final p = pairs[i];
                  return SavedAttractionTile(
                    savedAt: p.key.savedAt,
                    attraction: p.value,
                  )
                      .animate()
                      .fadeIn(delay: (i * 80).ms, duration: 300.ms)
                      .slideY(begin: 0.15, end: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}