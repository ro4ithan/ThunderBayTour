import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/enums/saved_item_type.dart';
import '../../../../core/utils/distance_utils.dart';
import '../../../../domain/models/restaurant.dart';
import '../../../providers/saved_provider.dart';
import '../../../shared_widgets/rating_stars.dart';

class SavedRestaurantTile extends ConsumerWidget {
  final Restaurant restaurant;
  final DateTime savedAt;

  const SavedRestaurantTile({
    super.key,
    required this.restaurant,
    required this.savedAt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distKm = DistanceUtils.haversineKm(
      AppConstants.thunderBayDowntownLat,
      AppConstants.thunderBayDowntownLng,
      restaurant.latitude,
      restaurant.longitude,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey('saved_rest_${restaurant.id}'),
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
          ref
              .read(savedProvider.notifier)
              .toggleSave(restaurant.id, SavedItemType.restaurant);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Removed from Saved & Tour'),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () => ref
                    .read(savedProvider.notifier)
                    .toggleSave(restaurant.id, SavedItemType.restaurant),
              ),
            ),
          );
        },
        child: Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push('/restaurant/${restaurant.id}'),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: restaurant.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                          width: 90, height: 90, color: Colors.grey),
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
                                restaurant.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
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
                              label: Text(restaurant.cuisine,
                                  style: const TextStyle(fontSize: 10)),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            const SizedBox(width: 6),
                            Text(restaurant.priceRange,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            RatingStars(rating: restaurant.rating, size: 14),
                            const SizedBox(width: 4),
                            Text(restaurant.rating.toString(),
                                style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 12),
                            Icon(Icons.location_on,
                                size: 12,
                                color: Colors.white.withValues(alpha: 0.55)),
                            Text(' ${DistanceUtils.format(distKm)}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Colors.white.withValues(alpha: 0.55))),
                          ],
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