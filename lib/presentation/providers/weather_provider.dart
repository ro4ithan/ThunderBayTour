import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/weather_service.dart';

final weatherServiceProvider = Provider((ref) => WeatherService());

final weatherProvider = FutureProvider.autoDispose<WeatherData>((ref) async {
  // Auto-refresh every 30 minutes
  ref.keepAlive();
  final service = ref.watch(weatherServiceProvider);
  return service.fetchCurrent();
});