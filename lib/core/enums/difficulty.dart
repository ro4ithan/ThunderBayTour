import 'package:flutter/material.dart';

enum Difficulty {
  easy('Easy', Icons.directions_walk, 1),
  moderate('Moderate', Icons.terrain, 2),
  active('Active', Icons.hiking, 3);

  final String label;
  final IconData icon;
  final int level;

  const Difficulty(this.label, this.icon, this.level);
}