import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/saved_item.dart';

class SavedNotifier extends StateNotifier<List<SavedItem>> {
  final SharedPreferences _prefs;
  static const _kIds = 'saved_attractions';
  static const _kTimes = 'saved_timestamps';

  SavedNotifier(this._prefs) : super([]) {
    _loadSaved();
  }

  void _loadSaved() {
    try {
      final saved = _prefs.getStringList(_kIds) ?? [];
      final timestamps = _prefs.getStringList(_kTimes) ?? [];
      state = List.generate(
        saved.length,
        (i) => SavedItem(
          attractionId: saved[i],
          savedAt: i < timestamps.length
              ? DateTime.tryParse(timestamps[i]) ?? DateTime.now()
              : DateTime.now(),
        ),
      );
    } catch (e) {
      state = [];
      debugPrint('Error loading saved: $e');
    }
  }

  void toggleSaved(String attractionId) {
    if (isSaved(attractionId)) {
      removeSaved(attractionId);
    } else {
      addSaved(attractionId);
    }
  }

  void addSaved(String attractionId) {
    if (isSaved(attractionId)) return;
    state = [
      ...state,
      SavedItem(attractionId: attractionId, savedAt: DateTime.now()),
    ];
    _persist();
  }

  void removeSaved(String attractionId) {
    state = state.where((i) => i.attractionId != attractionId).toList();
    _persist();
  }

  bool isSaved(String attractionId) =>
      state.any((i) => i.attractionId == attractionId);

  void _persist() {
    try {
      _prefs.setStringList(_kIds, state.map((e) => e.attractionId).toList());
      _prefs.setStringList(
          _kTimes, state.map((e) => e.savedAt.toIso8601String()).toList());
    } catch (e) {
      debugPrint('Error persisting saved: $e');
    }
  }
}

final savedProvider =
    StateNotifierProvider<SavedNotifier, List<SavedItem>>((ref) {
  throw UnimplementedError('Override in main.dart with SharedPreferences');
});