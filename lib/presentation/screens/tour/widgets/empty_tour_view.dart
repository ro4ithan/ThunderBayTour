import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class EmptyTourView extends StatelessWidget {
  const EmptyTourView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.explore, size: 80, color: AppColors.accent)
                .animate(onPlay: (c) => c.repeat())
                .rotate(duration: 3.seconds),
            const SizedBox(height: 24),
            const Text('Your tour is empty',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              'Head to Home and save attractions to build your perfect Thunder Bay tour',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white.withValues(alpha: 0.7)),
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
              child: const Text('Explore Attractions →'),
            ).animate().scale(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}