import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/attraction.dart';
import '../../../shared_widgets/rating_stars.dart';
import '../../../shared_widgets/season_badge.dart';
import '../../../shared_widgets/shimmer_card.dart';

class SliverHeroHeader extends StatelessWidget {
  final Attraction attraction;
  const SliverHeroHeader({super.key, required this.attraction});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.background,
      leading: _BlurIconButton(
        icon: Icons.arrow_back,
        onTap: () => context.pop(),
        semanticLabel: 'Back',
      ),
      actions: [
        _BlurIconButton(
          icon: Icons.share_outlined,
          onTap: () {
            Clipboard.setData(
              ClipboardData(text: 'Check out ${attraction.name}!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Link copied to clipboard')),
            );
          },
          semanticLabel: 'Share',
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        title: Text(
          attraction.name,
          style: AppTextStyles.titleMedium
              .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'attraction_${attraction.id}',
              child: CachedNetworkImage(
                imageUrl: attraction.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => const ShimmerCard(borderRadius: 0),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.surface,
                  child: const Icon(Icons.landscape_rounded, size: 80),
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0x99000000)],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    attraction.name,
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _CategoryPill(category: attraction.category),
                      ...attraction.bestSeasons.map(
                        (s) => SeasonBadge(season: s, compact: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      RatingStars(rating: attraction.rating, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        attraction.rating.toStringAsFixed(1),
                        style: AppTextStyles.titleMedium
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${attraction.reviewCount} reviews)',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
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
    );
  }
}

class _BlurIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;
  const _BlurIconButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.black.withValues(alpha: 0.35),
            child: IconButton(
              icon: Icon(icon, color: Colors.white),
              tooltip: semanticLabel,
              onPressed: onTap,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final dynamic category;
  const _CategoryPill({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.85),
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
