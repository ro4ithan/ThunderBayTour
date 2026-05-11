import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/season_utils.dart';
import '../../../../domain/models/attraction.dart';
import '../../../providers/saved_provider.dart';
import '../../../shared_widgets/rating_stars.dart';
import '../../../shared_widgets/season_badge.dart';
import '../../../shared_widgets/shimmer_card.dart';

class FeaturedCard extends ConsumerWidget {
  final Attraction attraction;
  const FeaturedCard({super.key, required this.attraction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedProvider);
    final isSaved = saved.any((s) => s.attractionId == attraction.id);
    final currentSeason = SeasonUtils.currentSeason();
    final isSeasonPick =
        attraction.bestSeasons.contains(currentSeason);

    return GestureDetector(
      onTap: () => context.push('/attraction/${attraction.id}'),
      child: RepaintBoundary(
        child: Hero(
          tag: 'featured_${attraction.id}',
          child: Material(
            color: Colors.transparent,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: attraction.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const ShimmerCard(),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.landscape_rounded,
                        size: 60,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  // Gradient overlay
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Color(0xB3000000),
                        ],
                        stops: [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                  // Top-left category tag
                  Positioned(
                    top: 14,
                    left: 14,
                    child: _CategoryTag(category: attraction.category),
                  ),
                  // Top-right season badge
                  if (isSeasonPick)
                    Positioned(
                      top: 14,
                      right: 56,
                      child: SeasonBadge(
                        season: currentSeason,
                        prefix: '${currentSeason.label} Pick',
                        compact: true,
                      ),
                    ),
                  // Save button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _SaveButton(
                      attractionId: attraction.id,
                      isSaved: isSaved,
                    ),
                  ),
                  // Bottom content
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          attraction.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          attraction.shortDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            RatingStars(rating: attraction.rating, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              attraction.rating.toStringAsFixed(1),
                              style: AppTextStyles.labelLarge
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${attraction.reviewCount})',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '📍 ${attraction.distanceFromDowntown}',
                                style: AppTextStyles.labelSmall
                                    .copyWith(color: Colors.white),
                              ),
                            ),
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

class _CategoryTag extends StatelessWidget {
  final dynamic category;
  const _CategoryTag({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends ConsumerStatefulWidget {
  final String attractionId;
  final bool isSaved;
  const _SaveButton({required this.attractionId, required this.isSaved});

  @override
  ConsumerState<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends ConsumerState<_SaveButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.1), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 30),
    ]).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() {
    _ctrl.forward(from: 0);
    final wasSaved = widget.isSaved;
    ref.read(savedProvider.notifier).toggleSaved(widget.attractionId);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.surface,
          content: Text(
            wasSaved
                ? 'Removed from Saved & Tour'
                : 'Added to Saved & Tour ✓',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textPrimary),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: widget.isSaved ? AppColors.accent : Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}