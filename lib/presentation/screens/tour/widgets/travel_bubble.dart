import 'package:flutter/material.dart';

class TravelBubble extends StatelessWidget {
  final int minutes;
  final String mode;
  const TravelBubble({super.key, required this.minutes, required this.mode});

  @override
  Widget build(BuildContext context) {
    final icon = mode == 'walk' ? '🚶' : '🚗';
    final label = mode == 'walk' ? 'walk' : 'drive';
    return Padding(
      padding: const EdgeInsets.only(left: 60, top: 4, bottom: 4),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Text('$icon $minutes min $label',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12)),
          ),
        ],
      ),
    );
  }
}