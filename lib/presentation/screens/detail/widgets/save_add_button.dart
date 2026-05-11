import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../providers/saved_provider.dart';

class SaveAddButton extends ConsumerStatefulWidget {
  final String attractionId;
  const SaveAddButton({super.key, required this.attractionId});

  @override
  ConsumerState<SaveAddButton> createState() => _SaveAddButtonState();
}

class _SaveAddButtonState extends ConsumerState<SaveAddButton>
    with TickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final AnimationController _burstCtrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.05), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 35),
    ]).animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOutBack));

    _burstCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _burstCtrl.dispose();
    super.dispose();
  }

  void _confirmRemove() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Remove from Tour?'),
        content: const Text('This will remove it from your saved list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, true);
              ref.read(savedProvider.notifier).toggleSaved(widget.attractionId);
            },
            child: Text(
              'Remove',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(bool isSaved) {
    _scaleCtrl.forward(from: 0);
    if (isSaved) {
      _confirmRemove();
    } else {
      _burstCtrl.forward(from: 0);
      ref.read(savedProvider.notifier).toggleSaved(widget.attractionId);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Added to Saved & Tour ✓')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saved = ref.watch(savedProvider);
    final isSaved = saved.any((s) => s.attractionId == widget.attractionId);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Burst dots
          AnimatedBuilder(
            animation: _burstCtrl,
            builder: (_, __) {
              if (_burstCtrl.value == 0) return const SizedBox.shrink();
              return SizedBox(
                width: 200,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(8, (i) {
                    final angle = (i * math.pi * 2) / 8;
                    final dist = 60 * _burstCtrl.value;
                    return Transform.translate(
                      offset: Offset(
                        math.cos(angle) * dist,
                        math.sin(angle) * dist,
                      ),
                      child: Opacity(
                        opacity: (1 - _burstCtrl.value).clamp(0.0, 1.0),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
          // Main button
          Semantics(
            label: isSaved ? 'Remove from tour' : 'Save to tour',
            button: true,
            child: ScaleTransition(
              scale: _scale,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _onTap(isSaved),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSaved ? AppColors.surface : AppColors.accent,
                    foregroundColor:
                        isSaved ? AppColors.accent : AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: isSaved
                          ? const BorderSide(color: AppColors.accent, width: 2)
                          : BorderSide.none,
                    ),
                    elevation: isSaved ? 0 : 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          isSaved ? Icons.check_circle : Icons.bookmark_outline,
                          key: ValueKey(isSaved),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isSaved ? '✓ In Your Tour' : 'Save & Add to Tour',
                        style: AppTextStyles.titleMedium.copyWith(
                          color:
                              isSaved ? AppColors.accent : AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (!isSaved) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.route, size: 20),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}