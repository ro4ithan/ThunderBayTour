import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/season.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/season_utils.dart';
import '../../../../data/services/weather_service.dart';
import '../../../providers/attractions_provider.dart';
import '../../../providers/date_context_provider.dart';
import '../../../providers/weather_provider.dart';

class SeasonBanner extends ConsumerWidget {
  const SeasonBanner({super.key});

  static const Map<Season, List<Color>> _gradients = {
    Season.summer: [Color(0xFFF4A261), Color(0xFFE76F51)],
    Season.winter: [Color(0xFF0D1B2A), Color(0xFF2A9D8F)],
    Season.fall: [Color(0xFFE63946), Color(0xFFF4A261)],
    Season.spring: [Color(0xFF1B4332), Color(0xFF52B788)],
  };

  /// Fallback if weather fetch fails — pure season-based.
  static const Map<Season, List<String>> _fallbackActivities = {
    Season.summer: ['Hiking', 'Swimming', 'Kayaking', 'Cycling', 'Photography'],
    Season.winter: ['Snowshoeing', 'Ice Fishing', 'Skiing', 'Northern Lights'],
    Season.fall: ['Leaf Peeping', 'Hiking', 'Photography', 'Camping'],
    Season.spring: ['Birdwatching', 'Fishing', 'Cycling', 'Waterfall Viewing'],
  };

  /// Smart activity list driven by live weather + season + time of day.
  List<String> _smartActivities(WeatherData w, Season season, String partOfDay) {
    final list = <String>[];

    // Bad weather → indoor first
    if (w.weatherCode >= 80 || w.precipitationMm > 3) {
      list.addAll(['Museums', 'Cafés', 'Indigenous Art', 'Brewery Tour']);
      return list;
    }

    // Cold extreme
    if (w.temperatureC < -15) {
      list.addAll(['Museums', 'Hot Cocoa Cafés', 'Northern Lights', 'Indoor Markets']);
      return list;
    }

    // Winter, decent conditions
    if (season == Season.winter && w.temperatureC < 2) {
      list.addAll(['Snowshoeing', 'Skiing', 'Ice Fishing']);
      if (partOfDay == 'evening' || partOfDay == 'night') list.add('Northern Lights');
      list.add('Frozen Waterfalls');
    }
    // Summer
    else if (season == Season.summer) {
      if (w.isGoodForWater) list.addAll(['Kayaking', 'Swimming']);
      if (w.isGoodForHiking) list.add('Hiking');
      if (w.uvIndex > 6) list.add('Photography');
      list.add('Cycling');
      if (partOfDay == 'evening') list.add('Marina Sunset');
    }
    // Spring
    else if (season == Season.spring) {
      list.addAll(['Birdwatching', 'Waterfall Viewing']);
      if (w.isGoodForHiking) list.add('Hiking');
      if (w.temperatureC > 8) list.add('Cycling');
      list.add('Fishing');
    }
    // Fall
    else if (season == Season.fall) {
      list.add('Leaf Peeping');
      if (w.isGoodForHiking) list.add('Hiking');
      list.addAll(['Photography', 'Camping']);
    }

    // Time-of-day overlay
    if (partOfDay == 'morning' && !list.contains('Sunrise Hikes')) {
      list.insert(0, 'Sunrise Spots');
    }

    return list.toSet().take(6).toList();
  }

  String _subtitle(WeatherData? w, String partOfDay, String? specialEvent) {
    if (specialEvent != null) return specialEvent;
    if (w == null) return SeasonUtils.greeting();

    final t = w.temperatureC.round();
    if (w.weatherCode >= 80) return 'Stormy $t°C — perfect for indoor gems';
    if (w.precipitationMm > 1) return 'Rainy $t°C — cozy cafés await';
    if (w.temperatureC < -15) return 'Bitter $t°C — bundle up or stay warm inside';
    if (w.temperatureC > 25 && partOfDay == 'afternoon') {
      return 'Warm $t°C — head to the lake';
    }
    if (partOfDay == 'evening') return 'Beautiful $t°C evening — sunset views await';
    if (partOfDay == 'morning') return 'Crisp $t°C morning — great for exploring';
    return 'Pleasant $t°C — ideal for adventure';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateCtx = ref.watch(dateContextProvider);
    final season = dateCtx.season;
    final weatherAsync = ref.watch(weatherProvider);
    final activeActivity = ref.watch(activityFilterProvider);
    final colors = _gradients[season]!;

    final activities = weatherAsync.maybeWhen(
      data: (w) => _smartActivities(w, season, dateCtx.partOfDay),
      orElse: () => _fallbackActivities[season]!,
    );

    final weather = weatherAsync.asData?.value;
    final subtitle = _subtitle(weather, dateCtx.partOfDay, dateCtx.specialEvent);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: colors.last.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(season.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Best of ${season.label} in Thunder Bay',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (weather != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(weather.emoji,
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          '${weather.temperatureC.round()}°',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: activities.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final activity = activities[i];
                  final isActive = activeActivity == activity;
                  return GestureDetector(
                    onTap: () {
                      ref.read(activityFilterProvider.notifier).state =
                          isActive ? null : activity;
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        activity,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isActive ? colors.last : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.15, end: 0);
  }
}