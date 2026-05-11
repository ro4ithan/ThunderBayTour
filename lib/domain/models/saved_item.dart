import '../../core/enums/saved_item_type.dart';

/// A single item the user has saved or added to their tour.
/// Can be either an attraction or a restaurant.
class SavedItem {
  final String id;            // attraction.id or restaurant.id
  final SavedItemType type;
  final DateTime savedAt;
  final bool inTour;          // true if added to tour plan
  final int? tourOrder;       // ordering index in the tour (nullable if not in tour)

  const SavedItem({
    required this.id,
    required this.type,
    required this.savedAt,
    this.inTour = false,
    this.tourOrder,
  });

  SavedItem copyWith({
    String? id,
    SavedItemType? type,
    DateTime? savedAt,
    bool? inTour,
    int? tourOrder,
  }) {
    return SavedItem(
      id: id ?? this.id,
      type: type ?? this.type,
      savedAt: savedAt ?? this.savedAt,
      inTour: inTour ?? this.inTour,
      tourOrder: tourOrder ?? this.tourOrder,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'savedAt': savedAt.toIso8601String(),
        'inTour': inTour,
        'tourOrder': tourOrder,
      };

  factory SavedItem.fromJson(Map<String, dynamic> json) => SavedItem(
        id: json['id'] as String,
        type: SavedItemType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => SavedItemType.attraction,
        ),
        savedAt: DateTime.parse(json['savedAt'] as String),
        inTour: json['inTour'] as bool? ?? false,
        tourOrder: json['tourOrder'] as int?,
      );
}