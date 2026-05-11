import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/services/weather_service.dart';
import '../../../providers/date_context_provider.dart';
import '../../../providers/weather_provider.dart';

class WeatherInsightsCard extends ConsumerWidget {
  const WeatherInsightsCard({super.key});

  /// Parse Open-Meteo ISO sunset "2026-05-10T20:42" → "8:42 PM"
  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso);
      int h = dt.hour;
      final m = dt.minute;
      final ampm = h >= 12 ? 'PM' : 'AM';
      final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      return '$h12:${m.toString().padLeft(2, '0')} $ampm';
    } catch (_) {
      return '--:--';
    }
  }

  ({List<String> good, List<String> skip}) _recommendations(
      WeatherData w, String partOfDay) {
    final good = <String>[];
    final skip = <String>[];

    // Outdoor adventure
    if (w.isGoodForHiking) {
      good.add('Hiking');
    } else if (w.temperatureC < 0) {
      skip.add('Long Hikes');
    } else if (w.precipitationMm > 2) {
      skip.add('Hiking');
    }

    // Water activities
    if (w.isGoodForWater) {
      good.add('Kayaking');
    } else if (w.temperatureC < 15) {
      skip.add('Swimming');
    }

    // Cold-weather
    if (w.temperatureC < 2 && w.weatherCode < 60) {
      good.add('Snowshoeing');
    }
    if (w.temperatureC < -5 && !w.isDay) {
      good.add('Northern Lights');
    }

    // Bad weather indoor
    if (w.weatherCode >= 80 || w.precipitationMm > 3) {
      good.addAll(['Museums', 'Cafés']);
      skip.add('Outdoor Tours');
    }

    // Sunset golden hour
    if (partOfDay == 'evening' && w.weatherCode < 50) {
      good.add('Sunset at Marina');
    }

    // High UV
    if (w.uvIndex > 7) skip.add('Midday Sun Exposure');

    // Wind
    if (w.windKph > 30) skip.add('Open Water');

    // Heat
    if (w.temperatureC > 28) skip.add('Strenuous Hikes');

    // De-dupe & cap
    return (
      good: good.toSet().take(3).toList(),
      skip: skip.toSet().take(2).toList(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    final dateCtx = ref.watch(dateContextProvider);

    return weatherAsync.when(
      loading: () => const _LoadingCard(),
      error: (e, _) => const SizedBox.shrink(),
      data: (w) {
        final recs = _recommendations(w, dateCtx.partOfDay);

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Text(w.emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Text(
                      'Today in Thunder Bay',
                      style: AppTextStyles.titleMedium
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Conditions row
                Text(
                  '${w.temperatureC.round()}°C · ${w.condition} · feels '
                  '${w.feelsLikeC.round()}°',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 6),

                // Sun & wind
                Row(
                  children: [
                    _miniStat('🌅', _formatTime(w.sunrise)),
                    const SizedBox(width: 14),
                    _miniStat('🌇', _formatTime(w.sunset)),
                    const SizedBox(width: 14),
                    _miniStat('💨', '${w.windKph.round()} km/h'),
                    if (w.uvIndex > 0) ...[
                      const SizedBox(width: 14),
                      _miniStat('🔆', 'UV ${w.uvIndex.round()}'),
                    ],
                  ],
                ),

                if (recs.good.isNotEmpty || recs.skip.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Colors.white12),
                  const SizedBox(height: 12),
                ],

                if (recs.good.isNotEmpty)
                  _recRow('✅', 'Great for', recs.good, Colors.greenAccent),
                if (recs.skip.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _recRow('⚠️', 'Skip today', recs.skip, Colors.orangeAccent),
                ],
              ],
            ),
          ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.1, end: 0),
        );
      },
    );
  }

  Widget _miniStat(String emoji, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 4),
        Text(
          value,
          style: AppTextStyles.labelSmall.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }

  Widget _recRow(
      String emoji, String label, List<String> items, Color tagColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: AppTextStyles.labelLarge.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: items
                .map((t) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tagColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        t,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: tagColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}