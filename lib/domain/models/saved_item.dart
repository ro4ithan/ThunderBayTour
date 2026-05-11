class SavedItem {
  final String attractionId;
  final DateTime savedAt;

  const SavedItem({
    required this.attractionId,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
        'attractionId': attractionId,
        'savedAt': savedAt.toIso8601String(),
      };

  factory SavedItem.fromJson(Map<String, dynamic> json) => SavedItem(
        attractionId: json['attractionId'] as String,
        savedAt: DateTime.parse(json['savedAt'] as String),
      );

  SavedItem copyWith({String? attractionId, DateTime? savedAt}) => SavedItem(
        attractionId: attractionId ?? this.attractionId,
        savedAt: savedAt ?? this.savedAt,
      );
}