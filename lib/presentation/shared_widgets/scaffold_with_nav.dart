import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'animated_bottom_nav.dart';

class ScaffoldWithNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNav({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: AnimatedBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}