import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class EmptySavedState extends StatelessWidget {
  const EmptySavedState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bookmark_border,
                    size: 80, color: AppColors.accent)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.05, 1.05),
                    duration: 900.ms),
            const SizedBox(height: 24),
            const Text('Nothing saved yet',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              'Explore attractions and tap the bookmark to save them here',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
              ),
              onPressed: () => context.go('/home'),
              child: const Text('Start Exploring →'),
            ).animate().scale(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}