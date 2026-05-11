import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../providers/saved_provider.dart';

class _NavItem {
  final IconData iconOutline;
  final IconData iconFilled;
  final String label;
  const _NavItem(this.iconOutline, this.iconFilled, this.label);
}

const _items = <_NavItem>[
  _NavItem(Icons.explore_outlined, Icons.explore, 'Home'),
  _NavItem(Icons.route_outlined, Icons.route, 'Tour'),
  _NavItem(Icons.bookmark_border, Icons.bookmark, 'Saved'),
];

class AnimatedBottomNav extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AnimatedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedCount = ref.watch(savedProvider).length;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: AppColors.divider.withOpacity(0.6),
            width: 0.6,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = constraints.maxWidth / _items.length;
            return Stack(
              children: [
                // Animated amber dot indicator
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  left: tabWidth * currentIndex + (tabWidth / 2) - 3,
                  bottom: 8,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Row(
                  children: List.generate(_items.length, (i) {
                    final isActive = i == currentIndex;
                    final showBadge = i == 1 && savedCount > 0;
                    return Expanded(
                      child: _NavTab(
                        item: _items[i],
                        isActive: isActive,
                        showBadge: showBadge,
                        badgeCount: savedCount,
                        onTap: () => onTap(i),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    )
        .animate()
        .slideY(
          begin: 1,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        )
        .fadeIn(duration: 400.ms);
  }
}

class _NavTab extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final bool showBadge;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavTab({
    required this.item,
    required this.isActive,
    required this.showBadge,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? AppColors.accent
        : AppColors.textPrimary.withOpacity(0.4);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with translateY animation + badge
              SizedBox(
                height: 30,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.elasticOut,
                      transform: Matrix4.translationValues(
                        0,
                        isActive ? -4 : 0,
                        0,
                      ),
                      child: Icon(
                        isActive ? item.iconFilled : item.iconOutline,
                        color: color,
                        size: 24,
                      ),
                    ),
                    if (showBadge)
                      Positioned(
                        right: -10,
                        top: -4,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          scale: showBadge ? 1.0 : 0.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.surface,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              badgeCount > 9 ? '9+' : '$badgeCount',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Label fades in only when active
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isActive ? 1.0 : 0.0,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  child: Padding(
                    padding: EdgeInsets.only(top: isActive ? 4 : 0),
                    child: Text(
                      item.label,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}