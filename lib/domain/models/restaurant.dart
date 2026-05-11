class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final double rating;
  final String priceRange; // "$", "$$", "$$$"
  final String imageUrl;
  final String localImagePath;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> mustTryDishes;
  final String openingHours;
  final bool isLocalFavorite;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.priceRange,
    required this.imageUrl,
    required this.localImagePath,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.mustTryDishes,
    required this.openingHours,
    required this.isLocalFavorite,
  });
}