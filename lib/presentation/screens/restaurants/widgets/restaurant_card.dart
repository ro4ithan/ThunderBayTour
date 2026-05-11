import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/enums/saved_item_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/restaurant.dart';
import '../../../providers/saved_provider.dart';
import '../../../shared_widgets/rating_stars.dart';

/// Restaurant tile used in the restaurants list.
/// Tappable, scales on press, displays image / name / cuisine / rating / price,
/// with bookmark toggle in the top-right of the image.
class RestaurantCard extends ConsumerStatefulWidget {
  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  final Restaurant restaurant;
  final VoidCallback onTap;

  @override
  ConsumerState<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends ConsumerState<RestaurantCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Stack(
                  children: [
                    _buildImage(),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: _RestaurantBookmark(restaurantId: r.id),
                    ),
                  ],
                ),
                Expanded(child: _buildBody(r)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      width: 110,
      height: 110,
      child: CachedNetworkImage(
        imageUrl: widget.restaurant.imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: AppColors.surface,
          highlightColor: AppColors.textSecondary.withValues(alpha: 0.1),
          child: Container(color: AppColors.surface),
        ),
        errorWidget: (_, __, ___) => Image.asset(
          widget.restaurant.localImagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.surface,
            child: Icon(
              Icons.restaurant,
              color: AppColors.textSecondary.withValues(alpha: 0.4),
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(Restaurant r) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            r.name,
            style: AppTextStyles.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            r.cuisine,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.65),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              RatingStars(rating: r.rating, size: 12),
              const SizedBox(width: 6),
              Text(r.rating.toStringAsFixed(1),
                  style: AppTextStyles.labelSmall),
              const Spacer(),
              Text(
                r.priceRange,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (r.isLocalFavorite) ...[
            const SizedBox(height: 6),
            _localFavBadge(),
          ],
        ],
      ),
    );
  }

  Widget _localFavBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department,
              size: 11, color: AppColors.accent),
          const SizedBox(width: 3),
          Text(
            'Local Favourite',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.accent,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantBookmark extends ConsumerStatefulWidget {
  final String restaurantId;
  const _RestaurantBookmark({required this.restaurantId});

  @override
  ConsumerState<_RestaurantBookmark> createState() =>
      _RestaurantBookmarkState();
}

class _RestaurantBookmarkState extends ConsumerState<_RestaurantBookmark> {
  double _scale = 1.0;

  Future<void> _toggle(bool wasSaved) async {
    setState(() => _scale = 0.85);
    await Future.delayed(const Duration(milliseconds: 90));
    if (!mounted) return;
    setState(() => _scale = 1.0);
    final notifier = ref.read(savedProvider.notifier);
    await notifier.toggleSave(widget.restaurantId, SavedItemType.restaurant);
    if (!wasSaved) {
      await notifier.addToTour(widget.restaurantId, SavedItemType.restaurant);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaved = ref.watch(savedProvider.select((list) => list.any(
        (s) =>
            s.id == widget.restaurantId &&
            s.type == SavedItemType.restaurant)));

    return GestureDetector(
      onTap: () => _toggle(isSaved),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_outline,
              key: ValueKey(isSaved),
              color: AppColors.accent,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}