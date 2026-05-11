import 'tour_stop.dart';

class TourRoute {
  final List<TourStop> stops;
  final int totalMinutes;
  final int totalTravelMinutes;
  final String startTime;
  final String endTime;

  const TourRoute({
    required this.stops,
    required this.totalMinutes,
    required this.totalTravelMinutes,
    required this.startTime,
    required this.endTime,
  });

  bool get isEmpty => stops.isEmpty;
  int get stopCount => stops.length;
}