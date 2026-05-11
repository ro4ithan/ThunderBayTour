import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/enums/saved_item_type.dart';
import '../../domain/models/saved_item.dart';

class SavedRepository {
  static const _key = 'saved_items_v2';

  final SharedPreferences _prefs;
  SavedRepository(this._prefs);

  /// Load all saved items from disk.
  List<SavedItem> getAll() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => SavedItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  /// Persist a list of saved items.
  Future<void> saveAll(List<SavedItem> items) async {
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, encoded);
  }

  /// Convenience: find a single item by (id, type). Returns null if missing.
  SavedItem? find(String id, SavedItemType type) {
    final all = getAll();
    try {
      return all.firstWhere((e) => e.id == id && e.type == type);
    } catch (_) {
      return null;
    }
  }
}