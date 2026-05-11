import '../../core/enums/category.dart';
import '../../core/enums/season.dart';
import '../../domain/models/attraction.dart';
import '../datasources/thunder_bay_data.dart';

class AttractionsRepository {
  const AttractionsRepository();

  List<Attraction> getAll() => ThunderBayData.attractions;

  Attraction? getById(String id) {
    try {
      return ThunderBayData.attractions.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Attraction> getByCategory(AttractionCategory category) =>
      ThunderBayData.attractions
          .where((a) => a.category == category)
          .toList(growable: false);

  List<Attraction> getBySeason(Season season) => ThunderBayData.attractions
      .where((a) => a.bestSeasons.contains(season))
      .toList(growable: false);

  List<Attraction> getNearest({int limit = 5}) {
    final list = [...ThunderBayData.attractions]
      ..sort((a, b) =>
          a.distanceFromDowntownKm.compareTo(b.distanceFromDowntownKm));
    return list.take(limit).toList(growable: false);
  }

  List<Attraction> getFeatured({int limit = 4}) {
    final list = [...ThunderBayData.attractions]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return list.take(limit).toList(growable: false);
  }

  List<Attraction> getIndigenousSites() => ThunderBayData.attractions
      .where((a) => a.isIndigenousSite)
      .toList(growable: false);
}