class TourStop {
  final String attractionId;
  final int orderIndex;
  final int recommendedMinutes;
  final int travelTimeToNextMinutes;
  final String travelModeToNext; // "drive" | "walk"
  final String tip;
  final String suggestedArrivalTime;
  final String suggestedDepartureTime;

  const TourStop({
    required this.attractionId,
    required this.orderIndex,
    required this.recommendedMinutes,
    required this.travelTimeToNextMinutes,
    required this.travelModeToNext,
    required this.tip,
    required this.suggestedArrivalTime,
    required this.suggestedDepartureTime,
  });

  TourStop copyWith({
    String? attractionId,
    int? orderIndex,
    int? recommendedMinutes,
    int? travelTimeToNextMinutes,
    String? travelModeToNext,
    String? tip,
    String? suggestedArrivalTime,
    String? suggestedDepartureTime,
  }) =>
      TourStop(
        attractionId: attractionId ?? this.attractionId,
        orderIndex: orderIndex ?? this.orderIndex,
        recommendedMinutes: recommendedMinutes ?? this.recommendedMinutes,
        travelTimeToNextMinutes:
            travelTimeToNextMinutes ?? this.travelTimeToNextMinutes,
        travelModeToNext: travelModeToNext ?? this.travelModeToNext,
        tip: tip ?? this.tip,
        suggestedArrivalTime:
            suggestedArrivalTime ?? this.suggestedArrivalTime,
        suggestedDepartureTime:
            suggestedDepartureTime ?? this.suggestedDepartureTime,
      );
}