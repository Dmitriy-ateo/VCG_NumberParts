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

  // ── LABYRINTH EXPLORER PROGRESSION ──────────────────────────────
  String _labyrinthUnlockedKey(String difficultyKey) => 'labyrinth_unlocked_$difficultyKey';
  String _labyrinthStarsKey(String difficultyKey, int level) => 'labyrinth_stars_${difficultyKey}_$level';

  Future<int> getLabyrinthUnlockedLevel(String difficultyKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_labyrinthUnlockedKey(difficultyKey)) ?? 1;
    } catch (_) {
      return 1;
    }
  }

  Future<void> unlockLabyrinthLevel(String difficultyKey, int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getInt(_labyrinthUnlockedKey(difficultyKey)) ?? 1;
      if (level > current) {
        await prefs.setInt(_labyrinthUnlockedKey(difficultyKey), level);
      }
    } catch (_) {}
  }

  Future<int> getLabyrinthStarsForLevel(String difficultyKey, int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_labyrinthStarsKey(difficultyKey, level)) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> saveLabyrinthStarsForLevel(String difficultyKey, int level, int stars) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final current = prefs.getInt(_labyrinthStarsKey(difficultyKey, level)) ?? 0;
      if (stars > current) {
        await prefs.setInt(_labyrinthStarsKey(difficultyKey, level), stars);
      }
    } catch (_) {}
  }

  Future<int> getLabyrinthTotalStars(String difficultyKey, int maxLevel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int total = 0;
      for (int i = 1; i <= maxLevel; i++) {
        total += prefs.getInt(_labyrinthStarsKey(difficultyKey, i)) ?? 0;
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  // ── TRAMPOLINE JUMPER HIGH SCORES ────────────────────────────────
  static const String _keyTrampolineHighScorePrefix = 'trampoline_highscore_';

  String _trampolineHighScoreKey(String difficultyKey) =>
      '$_keyTrampolineHighScorePrefix$difficultyKey';

  Future<int> getTrampolineHighScore(String difficultyKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_trampolineHighScoreKey(difficultyKey)) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<bool> saveTrampolineHighScore(String difficultyKey, int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentBest = prefs.getInt(_trampolineHighScoreKey(difficultyKey)) ?? 0;
      if (score > currentBest) {
        await prefs.setInt(_trampolineHighScoreKey(difficultyKey), score);
        return true; // New High Score!
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
