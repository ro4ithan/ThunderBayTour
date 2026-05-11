import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/models/attraction.dart';
import '../../providers/attractions_provider.dart';
import 'widgets/activities_section.dart';
import 'widgets/description_section.dart';
import 'widgets/gallery_section.dart';
import 'widgets/indigenous_legend_section.dart';
import 'widgets/practical_info_section.dart';
import 'widgets/save_add_button.dart';
import 'widgets/similar_attractions.dart';
import 'widgets/sliver_hero_header.dart';
import 'widgets/stats_row.dart';

class AttractionDetailScreen extends ConsumerWidget {
  final Attraction attraction;
  const AttractionDetailScreen({super.key, required this.attraction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(allAttractionsProvider);
    final similar = all
        .where((a) =>
            a.category == attraction.category && a.id != attraction.id)
        .take(3)
        .toList(growable: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverHeroHeader(attraction: attraction),
          SliverToBoxAdapter(
            child: StatsRow(
              rating: attraction.rating,
              visitMinutes: attraction.estimatedVisitMinutes,
              distanceKm: attraction.distanceFromDowntownKm,
            ),
          ),
          SliverToBoxAdapter(
            child: DescriptionSection(description: attraction.fullDescription),
          ),
          if (attraction.isIndigenousSite && attraction.legend != null)
            SliverToBoxAdapter(
              child: IndigenousLegendSection(legend: attraction.legend!),
            ),
          SliverToBoxAdapter(
            child: ActivitiesSection(activities: attraction.activities),
          ),
          SliverToBoxAdapter(
            child: GallerySection(images: attraction.galleryImages),
          ),
          SliverToBoxAdapter(
            child: PracticalInfoSection(attraction: attraction),
          ),
          SliverToBoxAdapter(
            child: SimilarAttractions(items: similar),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SaveAddButton(attractionId: attraction.id),
      ),
    );
  }
}