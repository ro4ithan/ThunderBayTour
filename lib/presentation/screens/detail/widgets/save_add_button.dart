import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/saved_item_type.dart';
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

  static const _type = SavedItemType.attraction;

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
        ]).animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut));
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
        content: const Text('This will remove it from your tour itinerary.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx, true);
              await ref
                  .read(savedProvider.notifier)
                  .removeFromTour(widget.attractionId, _type);
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTap(bool inTour) async {
    _scaleCtrl.forward(from: 0);
    if (inTour) {
      _confirmRemove();
    } else {
      _burstCtrl.forward(from: 0);
      final notifier = ref.read(savedProvider.notifier);

      // Ensure it's bookmarked too (so it shows in Saved tab).
      final alreadySaved = ref.read(savedProvider).any(
            (s) => s.id == widget.attractionId && s.type == _type,
          );
      if (!alreadySaved) {
        await notifier.toggleSave(widget.attractionId, _type);
      }
      await notifier.addToTour(widget.attractionId, _type);

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Added to your tour ✓')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Track inTour, not isSaved — this is the "Add to Tour" button.
    final inTour = ref.watch(savedProvider.select(
      (list) => list.any((s) =>
          s.id == widget.attractionId && s.type == _type && s.inTour),
    ));

    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
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
          Semantics(
            label: inTour ? 'Remove from tour' : 'Add to tour',
            button: true,
            child: ScaleTransition(
              scale: _scale,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _onTap(inTour),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        inTour ? AppColors.surface : AppColors.accent,
                    foregroundColor:
                        inTour ? AppColors.accent : AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: inTour
                          ? const BorderSide(color: AppColors.accent, width: 2)
                          : BorderSide.none,
                    ),
                    elevation: inTour ? 0 : 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          inTour ? Icons.check_circle : Icons.bookmark_outline,
                          key: ValueKey(inTour),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          inTour ? 'In Tour ✓' : 'Add to Tour',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleMedium.copyWith(
                            color:
                                inTour ? AppColors.accent : AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (!inTour) ...[
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
      );
  }
}