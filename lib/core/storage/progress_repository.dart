import 'package:shared_preferences/shared_preferences.dart';

class ProgressRepository {
  static const String _keyUnlockedLevel = 'number_bonds_unlocked_level';
  static const String _keyLevelStarsPrefix = 'number_bonds_stars_lvl_';

  // Default: Level 1 unlocked
  Future<int> getUnlockedLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyUnlockedLevel) ?? 1;
    } catch (_) {
      return 1;
    }
  }

  Future<void> unlockLevel(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getInt(_keyUnlockedLevel) ?? 1;
      if (level > current) {
        await prefs.setInt(_keyUnlockedLevel, level);
      }
    } catch (_) {}
  }

  Future<int> getStarsForLevel(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('$_keyLevelStarsPrefix$level') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> saveStarsForLevel(int level, int stars) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getInt('$_keyLevelStarsPrefix$level') ?? 0;
      if (stars > current) {
        await prefs.setInt('$_keyLevelStarsPrefix$level', stars);
      }
    } catch (_) {}
  }

  Future<int> getTotalStars(int maxLevel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int total = 0;
      for (int i = 1; i <= maxLevel; i++) {
        total += prefs.getInt('$_keyLevelStarsPrefix$i') ?? 0;
      }
      return total;
    } catch (_) {
      return 0;
    }
  }
}
