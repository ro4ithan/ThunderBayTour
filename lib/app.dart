import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'presentation/providers/attractions_provider.dart';
import 'presentation/providers/saved_provider.dart';
import 'presentation/screens/detail/attraction_detail_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/restaurant_detail/restaurant_detail_screen.dart';
import 'presentation/screens/restaurants/restaurants_screen.dart';
import 'presentation/screens/saved/saved_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/tour/tour_screen.dart';
import 'presentation/shared_widgets/scaffold_with_nav.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorTourKey = GlobalKey<NavigatorState>(debugLabel: 'tour');
final _shellNavigatorSavedKey = GlobalKey<NavigatorState>(debugLabel: 'saved');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        savedProvider.overrideWith((ref) => SavedNotifier(prefs)),
      ],
      child: const ThunderBayToursApp(),
    ),
  );
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // ---------------- Splash ----------------
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),

      // ---------------- Attraction Detail (full-screen) ----------------
      GoRoute(
        path: '/attraction/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final attraction =
              ref.read(attractionsRepositoryProvider).getById(id);
          if (attraction == null) {
            return const Scaffold(
              body: Center(child: Text('Attraction not found')),
            );
          }
          return AttractionDetailScreen(attraction: attraction);
        },
      ),

      // ---------------- Restaurant Detail (full-screen) ----------------
      GoRoute(
        path: '/restaurant/:id',
        name: 'restaurant-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => RestaurantDetailScreen(
          restaurantId: state.pathParameters['id']!,
        ),
      ),

      // ---------------- Main Shell (bottom nav) ----------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNav(navigationShell: navigationShell),
        branches: [
          // -------- Home branch --------
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: '/restaurants',
                name: 'restaurants',
                builder: (context, state) => const RestaurantsScreen(),
              ),
            ],
          ),
          // -------- Tour branch --------
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTourKey,
            routes: [
              GoRoute(
                path: '/tour',
                builder: (context, state) => const TourScreen(),
              ),
            ],
          ),
          // -------- Saved branch --------
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSavedKey,
            routes: [
              GoRoute(
                path: '/saved',
                builder: (context, state) => const SavedScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class ThunderBayToursApp extends ConsumerWidget {
  const ThunderBayToursApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'Thunder Bay Tours',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}