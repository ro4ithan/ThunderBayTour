import 'package:flutter/foundation.dart';

/// High-level grouping for restaurant browse / filter UI.
enum RestaurantCategory {
  fineDining,
  casual,
  international,
  brewery,
  cocktailBar,
  bakery,
  cafe,
  market,
  indigenous,
  specialty,
  vegetarian,
}

extension RestaurantCategoryX on RestaurantCategory {
  String get label {
    switch (this) {
      case RestaurantCategory.fineDining:
        return 'Fine Dining';
      case RestaurantCategory.casual:
        return 'Casual';
      case RestaurantCategory.international:
        return 'International';
      case RestaurantCategory.brewery:
        return 'Brewery';
      case RestaurantCategory.cocktailBar:
        return 'Cocktail Bar';
      case RestaurantCategory.bakery:
        return 'Bakery';
      case RestaurantCategory.cafe:
        return 'Café';
      case RestaurantCategory.market:
        return 'Market';
      case RestaurantCategory.indigenous:
        return 'Indigenous';
      case RestaurantCategory.specialty:
        return 'Specialty';
      case RestaurantCategory.vegetarian:
        return 'Vegetarian';
    }
  }
}

/// A single signature dish/drink with a short description.
@immutable
class SignatureDish {
  final String name;
  final String description;
  final String? priceHint; // optional, e.g. "$14"

  const SignatureDish({
    required this.name,
    required this.description,
    this.priceHint,
  });
}

@immutable
class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final String description; // 2-3 sentence story / what makes it special
  final double rating;
  final String priceRange; // "$", "$$", "$$$", "$$$$"
  final int priceLevel; // 1-4, mirrors priceRange for sorting
  final RestaurantCategory category;
  final String imageUrl; // Unsplash primary
  final String localImagePath; // local asset fallback
  final String address;
  final double latitude;
  final double longitude;
  final String phoneNumber; // e.g. "+1 807-555-1234" or "" if unknown
  final String? website; // null if none
  final List<String> mustTryDishes; // simple string list (used in cards/list)
  final List<SignatureDish> signatureDishes; // detailed (used in detail screen)
  final List<String> specialties; // chip tags e.g. ["Farm-to-table", "Locally sourced"]
  final String openingHours; // short summary used in cards (e.g. "Tue–Sun 5–10pm")
  final Map<String, String> weeklyHours; // detailed per-day, e.g. {"Monday": "Closed", ...}
  final bool isLocalFavorite;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.description,
    required this.rating,
    required this.priceRange,
    required this.priceLevel,
    required this.category,
    required this.imageUrl,
    required this.localImagePath,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    this.website,
    required this.mustTryDishes,
    required this.signatureDishes,
    required this.specialties,
    required this.openingHours,
    required this.weeklyHours,
    required this.isLocalFavorite,
  });
}