import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/tour_stop.dart';
import '../../../providers/attractions_provider.dart';
import '../../../providers/saved_provider.dart';

class TourTimelineCard extends ConsumerWidget {
  final TourStop stop;
  const TourTimelineCard({super.key, required this.stop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attractions = ref.watch(allAttractionsProvider);
    final a = attractions.firstWhere(
      (x) => x.id == stop.attractionId,
      orElse: () => attractions.first,
    );

    final h = stop.recommendedMinutes ~/ 60;
    final m = stop.recommendedMinutes % 60;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: a.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    Container(width: 70, height: 70, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(
                        label: Text(a.category.label,
                            style: const TextStyle(fontSize: 10)),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star,
                          size: 14, color: AppColors.accent),
                      Text(' ${a.rating}',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                      h > 0
                          ? 'Spend ~${h}h ${m}m here'
                          : 'Spend ~${m}m here',
                      style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  Text(
                    'Arrive by ${stop.suggestedArrivalTime} · Leave by ${stop.suggestedDepartureTime}',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12),
                  ),
                  if (stop.tip.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('💡 ${stop.tip}',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 12)),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: Colors.redAccent,
              onPressed: () => _confirmRemove(context, ref, a.name, a.id),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmRemove(
      BuildContext context, WidgetRef ref, String name, String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove from tour?'),
        content: Text('Remove "$name" from your tour?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Remove',
                  style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
    if (ok == true) {
      ref.read(savedProvider.notifier).removeSaved(id);
    }
  }
}