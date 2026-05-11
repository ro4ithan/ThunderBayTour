import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums/season.dart';
import '../../core/utils/season_utils.dart';

class DateContext {
  final DateTime now;
  final Season season;
  final String monthName;
  final int dayOfYear;
  final String? specialEvent; // e.g. "Sleeping Giant Loppet weekend"
  final bool isWeekend;
  final String partOfDay; // 'morning' / 'afternoon' / 'evening' / 'night'

  DateContext({
    required this.now,
    required this.season,
    required this.monthName,
    required this.dayOfYear,
    required this.specialEvent,
    required this.isWeekend,
    required this.partOfDay,
  });
}

final dateContextProvider = Provider<DateContext>((ref) {
  final now = DateTime.now();
  final season = SeasonUtils.currentSeason();

  const months = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  String partOfDay;
  final h = now.hour;
  if (h < 6) {
    partOfDay = 'night';
  } else if (h < 12) {
    partOfDay = 'morning';
  } else if (h < 17) {
    partOfDay = 'afternoon';
  } else if (h < 21) {
    partOfDay = 'evening';
  } else {
    partOfDay = 'night';
  }

  // Special Thunder Bay events (approximate)
  String? specialEvent;
  final m = now.month;
  final d = now.day;
  if (m == 3 && d >= 1 && d <= 10) specialEvent = 'Sleeping Giant Loppet season';
  if (m == 7 && d >= 1 && d <= 7) specialEvent = 'Canada Day & Blues Fest week';
  if (m == 8) specialEvent = 'Peak summer hiking & paddling';
  if (m == 9 && d >= 15) specialEvent = 'Fall colours peak — Mount McKay views';
  if (m == 12 && d >= 15) specialEvent = 'Holiday lights at Marina Park';
  if (m == 2) specialEvent = 'Winterlude — ice climbing season';

  return DateContext(
    now: now,
    season: season,
    monthName: months[now.month - 1],
    dayOfYear: int.parse(
        '${now.difference(DateTime(now.year, 1, 1)).inDays + 1}'),
    specialEvent: specialEvent,
    isWeekend: now.weekday == DateTime.saturday || now.weekday == DateTime.sunday,
    partOfDay: partOfDay,
  );
});