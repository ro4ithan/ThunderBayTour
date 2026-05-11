import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';

class ParticleBurst extends StatelessWidget {
  final bool trigger;
  final double radius;
  const ParticleBurst({super.key, required this.trigger, this.radius = 28});

  @override
  Widget build(BuildContext context) {
    if (!trigger) return const SizedBox.shrink();
    return IgnorePointer(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(8, (i) {
            final angle = (i * math.pi * 2) / 8;
            final dx = math.cos(angle);
            final dy = math.sin(angle);
            return Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            )
                .animate(key: ValueKey('p$i-$trigger'))
                .slideX(end: dx, duration: 600.ms, curve: Curves.easeOut)
                .slideY(end: dy, duration: 600.ms, curve: Curves.easeOut)
                .fadeOut(duration: 600.ms);
          }),
        ),
      ),
    );
  }
}