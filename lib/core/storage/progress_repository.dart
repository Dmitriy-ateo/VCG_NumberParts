import 'package:shared_preferences/shared_preferences.dart';
import '../../features/number_bonds_game/domain/models/level_data.dart';

class ProgressRepository {
  static const String _keyClassicUnlocked = 'number_bonds_unlocked_level';
  static const String _keyAdvancedUnlocked = 'advanced_unlocked_level';
  static const String _keyClassicStarsPrefix = 'number_bonds_stars_lvl_';
  static const String _keyAdvancedStarsPrefix = 'advanced_stars_lvl_';

  String _unlockedKey(LevelCategory category) =>
      category == LevelCategory.classic ? _keyClassicUnlocked : _keyAdvancedUnlocked;

  String _starsKey(LevelCategory category, int level) =>
      category == LevelCategory.classic
          ? '$_keyClassicStarsPrefix$level'
          : '$_keyAdvancedStarsPrefix$level';

  Future<int> getUnlockedLevel([LevelCategory category = LevelCategory.classic]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_unlockedKey(category)) ?? 1;
    } catch (_) {
      return 1;
    }
  }

  Future<void> unlockLevel(int level, [LevelCategory category = LevelCategory.classic]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getInt(_unlockedKey(category)) ?? 1;
      if (level > current) {
        await prefs.setInt(_unlockedKey(category), level);
      }
    } catch (_) {}
  }

  Future<int> getStarsForLevel(int level, [LevelCategory category = LevelCategory.classic]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_starsKey(category, level)) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> saveStarsForLevel(int level, int stars, [LevelCategory category = LevelCategory.classic]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getInt(_starsKey(category, level)) ?? 0;
      if (stars > current) {
        await prefs.setInt(_starsKey(category, level), stars);
      }
    } catch (_) {}
  }

  Future<int> getTotalStars(int maxLevel, [LevelCategory category = LevelCategory.classic]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int total = 0;
      for (int i = 1; i <= maxLevel; i++) {
        total += prefs.getInt(_starsKey(category, i)) ?? 0;
      }
      return total;
    } catch (_) {
      return 0;
    }
  }
}
