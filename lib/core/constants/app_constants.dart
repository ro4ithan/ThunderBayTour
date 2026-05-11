class AppConstants {
  AppConstants._();

  static const String appName = 'Thunder Bay Tours';

  // Thunder Bay downtown reference point for distance calculations
  static const double thunderBayDowntownLat = 48.3809;
  static const double thunderBayDowntownLng = -89.2477;

  // SharedPreferences keys
  static const String savedItemsKey = 'saved_items_v1';
  static const String tourStartTimeKey = 'tour_start_time_v1';

  // Default tour start time (8:30 AM in minutes from midnight)
  static const int defaultTourStartMinutes = 8 * 60 + 30;
}