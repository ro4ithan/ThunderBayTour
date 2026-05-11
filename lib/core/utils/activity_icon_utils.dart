class ActivityIconUtils {
  static const _map = {
    'hiking': '🥾',
    'photography': '📸',
    'swimming': '🏊',
    'cycling': '🚴',
    'fishing': '🎣',
    'camping': '⛺',
    'kayaking': '🛶',
    'skiing': '⛷️',
    'snowshoeing': '🥾',
    'ice fishing': '🎣',
    'birdwatching': '🦜',
    'leaf peeping': '🍁',
    'northern lights': '🌌',
    'waterfall viewing': '💧',
    'picnicking': '🧺',
    'climbing': '🧗',
    'sightseeing': '👀',
    'walking': '🚶',
  };

  static String emojiFor(String activity) {
    final key = activity.toLowerCase().trim();
    for (final entry in _map.entries) {
      if (key.contains(entry.key)) return entry.value;
    }
    return '✨';
  }

  static String tipFor(String activity) {
    final key = activity.toLowerCase();
    if (key.contains('hiking')) return 'Best trails open at 7 AM 🌅';
    if (key.contains('photography')) return 'Golden hour: 1 hr before sunset 📷';
    if (key.contains('swimming')) return 'Water warmest in late July 🌊';
    if (key.contains('kayak')) return 'Calmest waters in early morning 🛶';
    if (key.contains('fishing')) return 'License required — check ON regs 🎣';
    if (key.contains('camping')) return 'Book sites 3+ months ahead ⛺';
    if (key.contains('ski')) return 'Lift tickets cheaper midweek ⛷️';
    if (key.contains('snowshoe')) return 'Wear layers — temps drop fast ❄️';
    if (key.contains('northern lights')) return 'Best viewing: Sept–March 🌌';
    if (key.contains('birdwatch')) return 'Spring migration peaks in May 🦜';
    return 'Plan ahead and enjoy! ✨';
  }
}