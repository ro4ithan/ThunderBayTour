# 🏔️ Thunder Bay Tours — Flutter App

## Overview
Thunder Bay Tours is a beautifully crafted mobile tourism guide for Thunder Bay, Ontario, Canada. It features intelligent tour planning, Indigenous storytelling, and stunning animations — all without requiring map integration.

## Tech Stack
- **Framework:** Flutter (latest stable)
- **Language:** Dart
- **State Management:** Riverpod (`flutter_riverpod`)
- **Navigation:** GoRouter with `StatefulShellRoute.indexedStack()`
- **Local Storage:** SharedPreferences
- **Animations:** `flutter_animate`
- **IDE:** IntelliJ IDEA / VS Code with Flutter plugin

## Setup Instructions

### Prerequisites
- Flutter SDK (latest stable) — [install guide](https://docs.flutter.dev/get-started/install)
- IntelliJ IDEA or VS Code with Flutter plugin
- Android emulator (API 24+) or physical Android device
- Git

### Installation
```bash
git clone [GITHUB_LINK]
cd thunder_bay_tours
flutter pub get
flutter run
```

### IDE Setup
1. Open the project folder in IntelliJ IDEA or VS Code
2. Install the Flutter plugin (IntelliJ) or the Flutter extension by Dart Code (VS Code)
3. Flutter SDK is auto-detected. If not, set the SDK path in plugin settings
4. Select your Android emulator/device from the device selector
5. Press the run button (or `F5` in VS Code) to launch the app

## Architecture
Clean Architecture with 4 layers:

- `core/` — Theme, constants, enums, utilities, animation presets
- `domain/` — Data models (Attraction, Restaurant, TourStop, SavedItem, TourRoute)
- `data/` — Repositories and local data source (hardcoded Thunder Bay data)
- `presentation/` — Screens, widgets, Riverpod providers

## Features
- 🏠 **Home Screen** — Season-aware content, category filters, featured attractions, local restaurants, Indigenous spotlight
- 📍 **Smart Tour Planner** — Auto-orders saved attractions using Greedy Nearest Neighbor, calculates visit and travel times, computes best start time based on season daylight
- 💾 **Save System** — Persistent save/unsave with cross-screen sync (Home ↔ Tour ↔ Saved) powered by Riverpod
- 🏔️ **Rich Detail Views** — Expandable SliverAppBar hero images, animated CountUp stats, activities, galleries
- 🪶 **Indigenous Stories** — Anishinaabe legends for Sleeping Giant (Nana'bijou) and Mount McKay (Animiki)
- ✨ **Polished Animations** — CountUp stats, staggered reveals, particle bursts, spring micro-interactions, shimmer loading
- 🌗 **Dark Theme** — Lake Superior-inspired palette (deep blue, forest green, amber gold)
- 🍽️ **Local Restaurants** — Curated Thunder Bay dining with must-try dishes

## Screens
1. **Splash Screen** — Animated logo reveal with staggered text and loading bar
2. **Home Screen** — Discovery hub: season banner, category filters, featured carousel, attraction grid, restaurant row, Indigenous spotlight
3. **Attraction Detail** — SliverAppBar hero, animated stats, Indigenous legend, activities, gallery, save button with particle burst
4. **Tour Screen** — Timeline view with smart ordering, per-stop timing, travel estimates, best start time
5. **Saved Screen** — Sortable list (recently added / rating / distance) with swipe-to-delete and undo

## How the Tour Algorithm Works
- **Greedy Nearest Neighbor:** Starting from Thunder Bay downtown (48.3809, -89.2477), pick the nearest unvisited attraction via Haversine distance, then repeat
- **Travel Time:** Straight-line × 1.4 road factor; 60 km/h for >5km, 30 km/h for ≤5km
- **Best Start Time:** Computed backwards from season sunset minus total tour duration minus 30-min buffer, rounded to nearest 30 minutes

## Project Structure
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/ (app_theme, app_colors, app_text_styles)
│   ├── constants/ (app_constants)
│   ├── enums/ (category, season, difficulty)
│   ├── utils/ (season_utils, distance_utils)
│   └── animations/ (animation_presets)
├── domain/models/ (attraction, restaurant, saved_item, tour_stop, tour_route)
├── data/
│   ├── datasources/ (thunder_bay_data)
│   └── repositories/ (attractions, restaurants, saved)
└── presentation/
    ├── providers/ (attractions, saved, tour, sort)
    ├── screens/ (splash, home, detail, tour, saved)
    └── shared_widgets/ (scaffold_with_nav, animated_bottom_nav, rating_stars, season_badge, shimmer_card, particle_burst)
```

## Known Limitations
- Weather is hardcoded per season (no live weather API)
- Tour routing uses straight-line distance with road factor (no real road API)
- Image URLs require internet (local asset fallbacks provided)
- No user authentication or cloud sync

## Future Improvements
- Live weather API (OpenWeatherMap)
- User accounts + cloud sync (Firebase)
- AR viewfinder
- Full offline mode with pre-cached assets
- Multi-language support (EN/FR)
- Push notifications for seasonal events

## Author
Rohithan — Lakehead University
Built for [Course Name] — [Semester Year]