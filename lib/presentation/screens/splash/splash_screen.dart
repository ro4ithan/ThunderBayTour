import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loadingController;

  static const _totalDuration = Duration(milliseconds: 3000);
  static const _loadingDuration = Duration(milliseconds: 2500);

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: _loadingDuration,
    )..forward();

    Future.delayed(_totalDuration, () {
      if (!mounted) return;
      context.go('/home');
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'THUNDER BAY';

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            // Subtle radial glow behind logo
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.9,
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.35),
                      AppColors.primary,
                    ],
                  ),
                ),
              ),
            ),

            // Centered content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mountain logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.25),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.landscape_rounded,
                      size: 70,
                      color: AppColors.accent,
                    ),
                  ).animate().fadeIn(duration: 600.ms).scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                        duration: 800.ms,
                        curve: Curves.easeOutBack,
                      ),

                  const SizedBox(height: 28),

                  // Staggered letter animation for "THUNDER BAY"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(title.length, (i) {
                      final char = title[i];
                      return Text(
                        char,
                        style: AppTextStyles.displayLarge.copyWith(
                          fontSize: 28,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      )
                          .animate(delay: (600 + i * 50).ms)
                          .fadeIn(duration: 350.ms)
                          .slideY(
                            begin: 0.4,
                            end: 0,
                            duration: 350.ms,
                            curve: Curves.easeOut,
                          );
                    }),
                  ),

                  const SizedBox(height: 6),

                  // "TOURS" with shimmer sweep
                  Text(
                    'TOURS',
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.accent,
                      letterSpacing: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate(delay: 1400.ms).fadeIn(duration: 500.ms).shimmer(
                        duration: 1500.ms,
                        color: AppColors.textPrimary.withValues(alpha: 0.8),
                      ),

                  const SizedBox(height: 16),

                  Text(
                    'Discover the North Shore',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ).animate(delay: 1800.ms).fadeIn(duration: 500.ms),
                ],
              ),
            ),

            // Loading bar pinned to bottom
            Positioned(
              left: 48,
              right: 48,
              bottom: 48,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedBuilder(
                      animation: _loadingController,
                      builder: (context, _) {
                        return LinearProgressIndicator(
                          value: _loadingController.value,
                          minHeight: 3,
                          backgroundColor:
                              AppColors.textPrimary.withValues(alpha: 0.08),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.accent,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Loading your tour...',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
            ),
          ],
        ),
      ),
    );
  }
}
