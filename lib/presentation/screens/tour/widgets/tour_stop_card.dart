import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/saved_item_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/tour_stop.dart';

class TourStopCard extends StatelessWidget {
  final TourStop stop;
  final int index;
  final bool isLast;
  final VoidCallback onRemove;

  const TourStopCard({
    super.key,
    required this.stop,
    required this.index,
    required this.isLast,
    required this.onRemove,
  });

  String _fmtTime(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final ap = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ap';
  }

  String _fmtMinutes(Duration d) {
    final m = d.inMinutes;
    if (m < 60) return '${m}m';
    return '${m ~/ 60}h ${m % 60}m';
  }

  void _openDetail(BuildContext context) {
    if (stop.type == SavedItemType.attraction) {
      context.push('/attraction/${stop.id}');
    } else {
      context.push('/restaurant/${stop.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRestaurant = stop.type == SavedItemType.restaurant;

    return Column(
      children: [
        // Travel info (skip for first stop)
        if (stop.distanceFromPrevKm > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
            child: Row(
              children: [
                const Icon(Icons.directions_car,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  '${stop.distanceFromPrevKm.toStringAsFixed(1)} km • ${_fmtMinutes(stop.travelDuration)}',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        Dismissible(
          key: ValueKey('dismiss_${stop.id}_${stop.type.name}'),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => onRemove(),
          child: Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _openDetail(context),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Index circle
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: stop.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                            width: 70, height: 70, color: AppColors.divider),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isRestaurant
                                    ? Icons.restaurant
                                    : Icons.place_outlined,
                                size: 14,
                                color: AppColors.accent,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  stop.name,
                                  style: AppTextStyles.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_fmtTime(stop.arrivalTime)} → ${_fmtTime(stop.departureTime)}',
                            style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Stay ${_fmtMinutes(stop.stayDuration)}',
                            style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.drag_handle,
                        color: AppColors.textSecondary
                            .withValues(alpha: 0.5)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}