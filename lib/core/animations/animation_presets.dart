import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';

extension AnimationPresets on Widget {
  Widget fadeSlideUp({Duration delay = Duration.zero}) =>
      animate(delay: delay)
          .fadeIn(duration: 400.ms, curve: Curves.easeOut)
          .slideY(begin: 0.15, end: 0, duration: 400.ms, curve: Curves.easeOut);

  Widget fadeSlideRight({Duration delay = Duration.zero}) =>
      animate(delay: delay)
          .fadeIn(duration: 400.ms, curve: Curves.easeOut)
          .slideX(begin: -0.15, end: 0, duration: 400.ms, curve: Curves.easeOut);

  Widget scaleInPreset({Duration delay = Duration.zero}) =>
      animate(delay: delay).fadeIn(duration: 350.ms).scale(
            begin: const Offset(0.85, 0.85),
            end: const Offset(1, 1),
            duration: 350.ms,
            curve: Curves.easeOutBack,
          );

  Widget shimmerSweep() => animate(onPlay: (c) => c.repeat()).shimmer(
        duration: 1500.ms,
        color: AppColors.accent.withValues(alpha: 0.3),
      );

  Widget bounceIn({Duration delay = Duration.zero}) =>
      animate(delay: delay).scale(
        begin: const Offset(0, 0),
        end: const Offset(1, 1),
        duration: 500.ms,
        curve: Curves.elasticOut,
      );
}