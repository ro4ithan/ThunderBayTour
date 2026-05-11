import '../../data/services/weather_service.dart';
import '../../domain/models/attraction.dart';
import '../enums/category.dart';
import '../enums/season.dart';

enum AttractionFit { perfect, good, okay, betterIndoors, closedSeason }

class AttractionScore {
  final double score; // higher = better fit today
  final AttractionFit fit;
  final String? badgeLabel;
  final String? badgeEmoji;

  const AttractionScore({
    required this.score,
    required this.fit,
    this.badgeLabel,
    this.badgeEmoji,
  });
}

class AttractionScorer {
  /// Score an attraction for today's weather + season.
  static AttractionScore score(
    Attraction a,
    WeatherData? w,
    Season currentSeason,
  ) {
    // Hard seasonal mismatch (only listed in 1 season and it's not today's)
    if (a.bestSeasons.isNotEmpty &&
        !a.bestSeasons.contains(currentSeason) &&
        a.bestSeasons.length == 1) {
      return const AttractionScore(
        score: -50,
        fit: AttractionFit.closedSeason,
        badgeLabel: 'Off-season',
        badgeEmoji: '🚫',
      );
    }

    if (w == null) {
      return const AttractionScore(score: 0, fit: AttractionFit.okay);
    }

    double s = 0;

    // Categorize by behavior
    final isOutdoor = a.category == AttractionCategory.nature ||
        a.category == AttractionCategory.waterfront;
    final isIndoorish = a.category == AttractionCategory.history ||
        a.category == AttractionCategory.culture;
    final isIndigenous = a.category == AttractionCategory.indigenous;
    final isWaterfront = a.category == AttractionCategory.waterfront;

    // Weather flags
    final stormy = w.weatherCode >= 80 || w.precipitationMm > 3;
    final rainy = w.precipitationMm > 1 && w.precipitationMm <= 3;
    final coldExtreme = w.temperatureC < -15;
    final windy = w.windKph > 30;
    final perfectTemp = w.temperatureC >= 10 && w.temperatureC <= 24;
    final warmEnoughForWater = w.temperatureC >= 15;

    if (stormy || coldExtreme) {
      if (isIndoorish) s += 40;
      if (isOutdoor) s -= 35;
      if (isIndigenous) s += 10; // many indigenous sites have indoor/cultural elements
    } else if (rainy) {
      if (isIndoorish) s += 20;
      if (isOutdoor) s -= 15;
      if (isIndigenous) s += 5;
    } else {
      // Decent weather
      if (isOutdoor && perfectTemp) s += 30;
      if (isOutdoor && w.isGoodForHiking) s += 10;
      if (isWaterfront && warmEnoughForWater) s += 12;
      if (isWaterfront && !warmEnoughForWater) s -= 8;
      if (isOutdoor && windy) s -= 8;
      if (isIndoorish) s += 5;
      if (isIndigenous) s += 8;
    }

    // Season match bonus
    if (a.bestSeasons.contains(currentSeason)) s += 15;

    // Rating tie-breaker
    s += a.rating * 2;

    // Bucket into fit
    AttractionFit fit;
    String? label;
    String? emoji;
    if (stormy && isOutdoor) {
      fit = AttractionFit.betterIndoors;
      label = 'Better indoors';
      emoji = '🌧️';
    } else if (s >= 45) {
      fit = AttractionFit.perfect;
      label = 'Perfect today';
      emoji = '✨';
    } else if (s >= 25) {
      fit = AttractionFit.good;
    } else if (s < 0) {
      fit = AttractionFit.betterIndoors;
      label = 'Skip today';
      emoji = '⚠️';
    } else {
      fit = AttractionFit.okay;
    }

    return AttractionScore(
      score: s,
      fit: fit,
      badgeLabel: label,
      badgeEmoji: emoji,
    );
  }
}