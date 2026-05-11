import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortOption { recentlyAdded, rating, distance }

final sortProvider = StateProvider<SortOption>((ref) => SortOption.recentlyAdded);