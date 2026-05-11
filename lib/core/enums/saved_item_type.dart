/// What kind of item is saved / added to the tour.
enum SavedItemType {
  attraction,
  restaurant;

  String get label {
    switch (this) {
      case SavedItemType.attraction:
        return 'Attraction';
      case SavedItemType.restaurant:
        return 'Restaurant';
    }
  }
}