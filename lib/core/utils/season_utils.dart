import 'package:flutter/material.dart';

import '../enums/season.dart';

class SeasonUtils {
  static Season getCurrentSeason() {
    final now = DateTime.now();
    final m = now.month;
    final d = now.day;

    if ((m == 3 && d >= 20) || m == 4 || m == 5 || (m == 6 && d <= 20)) {
      return Season.spring;
    } else if ((m == 6 && d >= 21) || m == 7 || m == 8 || (m == 9 && d <= 22)) {
      return Season.summer;
    } else if ((m == 9 && d >= 23) || m == 10 || m == 11 || (m == 12 && d <= 20)) {
      return Season.fall;
    } else {
      return Season.winter;
    }
  }

  /// Backwards-compat alias used elsewhere in the app
  static Season currentSeason() => getCurrentSeason();

  static String getSunsetLabel(Season season) {
    switch (season) {
      case Season.summer:
        return '9:30 PM';
      case Season.fall:
        return '7:00 PM';
      case Season.winter:
        return '5:00 PM';
      case Season.spring:
        return '8:00 PM';
    }
  }

  /// Returns a DateTime for today's sunset (used by tour calculator)
  static DateTime getSunsetTime([Season? season]) {
    final s = season ?? getCurrentSeason();
    final now = DateTime.now();
    int hour;
    int minute;
    switch (s) {
      case Season.summer:
        hour = 21;
        minute = 30;
        break;
      case Season.fall:
        hour = 19;
        minute = 0;
        break;
      case Season.winter:
        hour = 17;
        minute = 0;
        break;
      case Season.spring:
        hour = 20;
        minute = 0;
        break;
    }
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  static String getTemperature(Season season) {
    switch (season) {
      case Season.summer:
        return '☀️ 22°C';
      case Season.fall:
        return '🍂 8°C';
      case Season.winter:
        return '❄️ −12°C';
      case Season.spring:
        return '🌱 10°C';
    }
  }

  static LinearGradient getSeasonGradient(Season season) {
    switch (season) {
      case Season.summer:
        return const LinearGradient(
            colors: [Color(0xFFF4A261), Color(0xFFE76F51)]);
      case Season.fall:
        return const LinearGradient(
            colors: [Color(0xFFE63946), Color(0xFFF4A261)]);
      case Season.winter:
        return const LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF2A9D8F)]);
      case Season.spring:
        return const LinearGradient(
            colors: [Color(0xFF1B4332), Color(0xFF52B788)]);
    }
  }

  static List<String> getSeasonActivities(Season season) {
    switch (season) {
      case Season.summer:
        return ['Hiking', 'Swimming', 'Kayaking', 'Cycling', 'Photography', 'Camping'];
      case Season.fall:
        return ['Leaf Peeping', 'Hiking', 'Photography', 'Camping', 'Fishing'];
      case Season.winter:
        return ['Snowshoeing', 'Ice Fishing', 'Skiing', 'Northern Lights', 'Snowmobiling'];
      case Season.spring:
        return ['Birdwatching', 'Fishing', 'Cycling', 'Waterfall Viewing', 'Photography'];
    }
  }

  static String greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }
}