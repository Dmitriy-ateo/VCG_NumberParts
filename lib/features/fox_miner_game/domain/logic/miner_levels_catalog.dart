import '../models/miner_level_data.dart';

class MinerLevelsCatalog {
  static const List<MinerLevelData> allLevels = [
    // Tier 1: Discovery (teens and twenties)
    MinerLevelData(levelNumber: 1, targetNumber: 14, tier: MinerDifficultyTier.beginner),
    MinerLevelData(levelNumber: 2, targetNumber: 23, tier: MinerDifficultyTier.beginner),
    MinerLevelData(levelNumber: 3, targetNumber: 17, tier: MinerDifficultyTier.beginner),
    MinerLevelData(levelNumber: 4, targetNumber: 28, tier: MinerDifficultyTier.beginner),

    // Tier 2: Tens and Ones Decomposing
    MinerLevelData(levelNumber: 5, targetNumber: 35, tier: MinerDifficultyTier.intermediate),
    MinerLevelData(levelNumber: 6, targetNumber: 42, tier: MinerDifficultyTier.intermediate),
    MinerLevelData(levelNumber: 7, targetNumber: 56, tier: MinerDifficultyTier.intermediate),
    MinerLevelData(levelNumber: 8, targetNumber: 64, tier: MinerDifficultyTier.intermediate),

    // Tier 3: High Numbers
    MinerLevelData(levelNumber: 9, targetNumber: 72, tier: MinerDifficultyTier.advanced),
    MinerLevelData(levelNumber: 10, targetNumber: 83, tier: MinerDifficultyTier.advanced),
    MinerLevelData(levelNumber: 11, targetNumber: 91, tier: MinerDifficultyTier.advanced),
    MinerLevelData(levelNumber: 12, targetNumber: 87, tier: MinerDifficultyTier.advanced),

    // Tier 4: Master (including round tens testing zero singles, plus big 99)
    MinerLevelData(levelNumber: 13, targetNumber: 30, tier: MinerDifficultyTier.master),
    MinerLevelData(levelNumber: 14, targetNumber: 50, tier: MinerDifficultyTier.master),
    MinerLevelData(levelNumber: 15, targetNumber: 80, tier: MinerDifficultyTier.master),
    MinerLevelData(levelNumber: 16, targetNumber: 99, tier: MinerDifficultyTier.master),
  ];

  static MinerLevelData getLevel(int levelNumber) {
    if (levelNumber < 1) return allLevels.first;
    if (levelNumber > allLevels.length) return allLevels.last;
    return allLevels[levelNumber - 1];
  }

  static MinerLevelData? getNextLevel(int currentLevelNumber) {
    if (currentLevelNumber >= allLevels.length) return null;
    return allLevels[currentLevelNumber]; // 1-based index maps to array[currentLevelNumber]
  }
}
