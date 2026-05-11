/// Time-of-day meal slots used to label restaurants in the tour timeline
/// and to suggest meal stops when no restaurant is added.
enum MealSlot {
  breakfast,
  lunch,
  snack,
  dinner,
  none;

  String get label {
    switch (this) {
      case MealSlot.breakfast:
        return 'Breakfast';
      case MealSlot.lunch:
        return 'Lunch';
      case MealSlot.snack:
        return 'Snack';
      case MealSlot.dinner:
        return 'Dinner';
      case MealSlot.none:
        return '';
    }
  }

  String get emoji {
    switch (this) {
      case MealSlot.breakfast:
        return '☕';
      case MealSlot.lunch:
        return '🍽️';
      case MealSlot.snack:
        return '🥐';
      case MealSlot.dinner:
        return '🍷';
      case MealSlot.none:
        return '';
    }
  }

  /// Determine slot from time-of-day (24h hours, 0–23).
  static MealSlot fromHour(int hour) {
    if (hour >= 6 && hour < 11) return MealSlot.breakfast;
    if (hour >= 11 && hour < 15) return MealSlot.lunch;
    if (hour >= 15 && hour < 17) return MealSlot.snack;
    if (hour >= 17 && hour < 22) return MealSlot.dinner;
    return MealSlot.none;
  }
}