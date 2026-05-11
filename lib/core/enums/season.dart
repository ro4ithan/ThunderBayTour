import 'package:flutter/material.dart';

enum Season {
  spring('Spring', Icons.local_florist_outlined, '🌸'),
  summer('Summer', Icons.wb_sunny_outlined, '☀️'),
  fall('Fall', Icons.park_outlined, '🍁'),
  winter('Winter', Icons.ac_unit_outlined, '❄️');

  final String label;
  final IconData icon;
  final String emoji;

  const Season(this.label, this.icon, this.emoji);
}