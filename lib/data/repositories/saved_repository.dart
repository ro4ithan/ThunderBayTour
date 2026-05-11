import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/models/saved_item.dart';

class SavedRepository {
  const SavedRepository();

  Future<List<SavedItem>> loadAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(AppConstants.savedItemsKey) ?? const [];
      return raw
          .map((s) {
            try {
              return SavedItem.fromJson(
                jsonDecode(s) as Map<String, dynamic>,
              );
            } catch (_) {
              return null;
            }
          })
          .whereType<SavedItem>()
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  Future<bool> saveAll(List<SavedItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw =
          items.map((i) => jsonEncode(i.toJson())).toList(growable: false);
      return prefs.setStringList(AppConstants.savedItemsKey, raw);
    } catch (_) {
      return false;
    }
  }

  Future<bool> add(String attractionId) async {
    try {
      final current = await loadAll();
      if (current.any((i) => i.attractionId == attractionId)) return true;
      final updated = [
        ...current,
        SavedItem(attractionId: attractionId, savedAt: DateTime.now()),
      ];
      return saveAll(updated);
    } catch (_) {
      return false;
    }
  }

  Future<bool> remove(String attractionId) async {
    try {
      final current = await loadAll();
      final updated = current
          .where((i) => i.attractionId != attractionId)
          .toList(growable: false);
      return saveAll(updated);
    } catch (_) {
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.remove(AppConstants.savedItemsKey);
    } catch (_) {
      return false;
    }
  }

  Future<int> loadTourStartMinutes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(AppConstants.tourStartTimeKey) ??
          AppConstants.defaultTourStartMinutes;
    } catch (_) {
      return AppConstants.defaultTourStartMinutes;
    }
  }

  Future<bool> saveTourStartMinutes(int minutes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.setInt(AppConstants.tourStartTimeKey, minutes);
    } catch (_) {
      return false;
    }
  }
}