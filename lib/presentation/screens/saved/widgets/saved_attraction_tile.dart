import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/distance_utils.dart';
import '../../../../domain/models/attraction.dart';
import '../../../providers/saved_provider.dart';
import '../../../shared_widgets/rating_stars.dart';
import '../../../shared_widgets/season_badge.dart';

class SavedAttractionTile extends ConsumerWidget {
  final Attraction attraction;
  final DateTime savedAt;

  const SavedAttractionTile({
    super.key,
    required this.attraction,
    required this.savedAt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distKm = DistanceUtils.haversineKm(
      AppConstants.thunderBayDowntownLat,
      AppConstants.thunderBayDowntownLng,
      attraction.latitude,
      attraction.longitude,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey('saved_${attraction.id}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 28),
        ),
        onDismissed: (_) {
          ref.read(savedProvider.notifier).removeSaved(attraction.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Removed from Saved & Tour'),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () =>
                    ref.read(savedProvider.notifier).addSaved(attraction.id),
              ),
            ),
          );
        },
        child: Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push('/attraction/${attraction.id}'),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'attraction_${attraction.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: attraction.imageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                            width: 90, height: 90, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                attraction.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'In Tour ✓',
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Chip(
                              label: Text(attraction.category.label,
                                  style: const TextStyle(fontSize: 10)),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            RatingStars(rating: attraction.rating, size: 14),
                            const SizedBox(width: 4),
                            Text(attraction.rating.toString(),
                                style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 12),
                            Icon(Icons.location_on,
                                size: 12,
                                color: Colors.white.withValues(alpha: 0.55)),
                            Text(' ${DistanceUtils.format(distKm)}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white
                                        .withValues(alpha: 0.55))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: attraction.bestSeasons
                              .map((s) => SeasonBadge(season: s))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}