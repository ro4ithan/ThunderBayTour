import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/attractions_provider.dart';
import '../../providers/date_context_provider.dart';
import '../../providers/weather_provider.dart';
import 'widgets/category_filter_chips.dart';
import 'widgets/grid_attraction_card.dart';
import 'widgets/indigenous_spotlight.dart';
import 'widgets/near_you_section.dart';
import 'widgets/restaurant_row.dart';
import 'widgets/season_banner.dart';
import 'widgets/weather_insights_card.dart';
import 'widgets/eat_drink_entry.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting(String partOfDay) {
    switch (partOfDay) {
      case 'morning':
        return 'Good Morning,';
      case 'afternoon':
        return 'Good Afternoon,';
      case 'evening':
        return 'Good Evening,';
      default:
        return 'Hello,';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredAttractionsProvider);
    final dateCtx = ref.watch(dateContextProvider);
    final weatherAsync = ref.watch(weatherProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(weatherProvider);
            await ref.read(weatherProvider.future);
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              // SECTION 1 — Top header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting(dateCtx.partOfDay),
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Discover Thunder Bay',
                              style: AppTextStyles.headlineLarge
                                  .copyWith(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                      // LIVE Weather chip
                      weatherAsync.when(
                        loading: () => _tempChip('⏳', '--°'),
                        error: (_, __) => _tempChip(
                            dateCtx.season.emoji, '--°'),
                        data: (w) => _tempChip(
                            w.emoji, '${w.temperatureC.round()}°C'),
                      ),
                    ],
                  ),
                ),
              ),

              // SECTION 2 — Season banner (already live)
              const SliverToBoxAdapter(child: SeasonBanner()),

              // SECTION 2.5 — NEW Weather Insights card
              const SliverToBoxAdapter(child: WeatherInsightsCard()),

              // SECTION 3 — Category filter chips
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: CategoryFilterChips(),
                ),
              ),

              // SECTION 4 — Featured / Near You
              const SliverToBoxAdapter(child: NearYouSection()),

              // SECTION 5 — All Attractions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      Text('All Attractions',
                          style: AppTextStyles.headlineMedium),
                      const Spacer(),
                      Text(
                        '${filtered.length} found',
                        style: AppTextStyles.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      return GridAttractionCard(attraction: filtered[i])
                          .animate(delay: (60 * i).ms)
                          .fadeIn(duration: 350.ms)
                          .slideY(begin: 0.15, end: 0);
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),

              // SECTION 6 — Restaurants
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: RestaurantRow(),
                ),
              ),

              // SECTION 6.5 — Eat & Drink full list entry
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: EatDrinkEntry(),
                ),
              ),

              // SECTION 7 — Indigenous spotlight
              const SliverToBoxAdapter(child: IndigenousSpotlight()),

              const SliverToBoxAdapter(child: SizedBox(height: 110)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tempChip(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }
}