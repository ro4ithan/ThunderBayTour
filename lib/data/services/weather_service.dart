import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temperatureC;
  final double feelsLikeC;
  final int weatherCode;
  final double windKph;
  final double precipitationMm;
  final String sunrise;
  final String sunset;
  final double uvIndex;
  final bool isDay;

  WeatherData({
    required this.temperatureC,
    required this.feelsLikeC,
    required this.weatherCode,
    required this.windKph,
    required this.precipitationMm,
    required this.sunrise,
    required this.sunset,
    required this.uvIndex,
    required this.isDay,
  });

  /// Open-Meteo WMO weather codes → human label + emoji
  String get condition {
    if (weatherCode == 0) return 'Clear';
    if (weatherCode <= 3) return 'Partly Cloudy';
    if (weatherCode <= 48) return 'Foggy';
    if (weatherCode <= 67) return 'Rainy';
    if (weatherCode <= 77) return 'Snowy';
    if (weatherCode <= 82) return 'Showers';
    if (weatherCode <= 86) return 'Snow Showers';
    if (weatherCode <= 99) return 'Thunderstorm';
    return 'Unknown';
  }

  String get emoji {
    if (!isDay) return '🌙';
    if (weatherCode == 0) return '☀️';
    if (weatherCode <= 3) return '⛅';
    if (weatherCode <= 48) return '🌫️';
    if (weatherCode <= 67) return '🌧️';
    if (weatherCode <= 77) return '❄️';
    if (weatherCode <= 82) return '🌦️';
    if (weatherCode <= 86) return '🌨️';
    return '⛈️';
  }

  bool get isGoodForOutdoors =>
      temperatureC >= -15 &&
      temperatureC <= 32 &&
      precipitationMm < 2 &&
      windKph < 40 &&
      weatherCode < 80;

  bool get isGoodForWater =>
      temperatureC >= 15 && precipitationMm < 1 && windKph < 25;

  bool get isGoodForHiking =>
      temperatureC >= 5 &&
      temperatureC <= 28 &&
      precipitationMm < 1 &&
      weatherCode < 60;
}

class WeatherService {
  // Thunder Bay coordinates
  static const double _lat = 48.3809;
  static const double _lon = -89.2477;

  Future<WeatherData> fetchCurrent() async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$_lat&longitude=$_lon'
      '&current=temperature_2m,apparent_temperature,is_day,precipitation,'
      'weather_code,wind_speed_10m'
      '&daily=sunrise,sunset,uv_index_max'
      '&timezone=America%2FToronto'
      '&forecast_days=1',
    );

    final response = await http.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('Weather fetch failed: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;

    return WeatherData(
      temperatureC: (current['temperature_2m'] as num).toDouble(),
      feelsLikeC: (current['apparent_temperature'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      windKph: (current['wind_speed_10m'] as num).toDouble(),
      precipitationMm: (current['precipitation'] as num).toDouble(),
      sunrise: (daily['sunrise'] as List).first as String,
      sunset: (daily['sunset'] as List).first as String,
      uvIndex: ((daily['uv_index_max'] as List).first as num?)?.toDouble() ?? 0,
      isDay: (current['is_day'] as num).toInt() == 1,
    );
  }
}