import '../../core/constants/app_constants.dart';
import '../../core/enums/category.dart';
import '../../core/enums/season.dart';
import '../../core/utils/distance_utils.dart';

class IndigenousLegend {
  final String title;
  final String story;
  final String culturalNote;

  const IndigenousLegend({
    required this.title,
    required this.story,
    required this.culturalNote,
  });
}

class Attraction {
  final String id;
  final String name;
  final String shortDescription;
  final String fullDescription;
  final String imageUrl;
  final String localImagePath;
  final List<String> galleryImages;
  final double rating;
  final int reviewCount;
  final int estimatedVisitMinutes;
  final AttractionCategory category;
  final List<Season> bestSeasons;
  final List<String> activities;
  final String openingHours;
  final String admissionFee;
  final bool isIndigenousSite;
  final IndigenousLegend? legend;
  final String bestTimeToVisit;
  final String parkingInfo;
  final bool isWheelchairAccessible;
  final bool isFamilyFriendly;
  final double latitude;
  final double longitude;

  const Attraction({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.fullDescription,
    required this.imageUrl,
    required this.localImagePath,
    required this.galleryImages,
    required this.rating,
    required this.reviewCount,
    required this.estimatedVisitMinutes,
    required this.category,
    required this.bestSeasons,
    required this.activities,
    required this.openingHours,
    required this.admissionFee,
    required this.isIndigenousSite,
    this.legend,
    required this.bestTimeToVisit,
    required this.parkingInfo,
    required this.isWheelchairAccessible,
    required this.isFamilyFriendly,
    required this.latitude,
    required this.longitude,
  });

  /// Distance from Thunder Bay downtown, formatted ("2.3 km").
  String get distanceFromDowntown {
    final km = DistanceUtils.haversineKm(
      latitude,
      longitude,
      AppConstants.thunderBayDowntownLat,
      AppConstants.thunderBayDowntownLng,
    );
    return DistanceUtils.format(km);
  }

  double get distanceFromDowntownKm => DistanceUtils.haversineKm(
        latitude,
        longitude,
        AppConstants.thunderBayDowntownLat,
        AppConstants.thunderBayDowntownLng,
      );
}