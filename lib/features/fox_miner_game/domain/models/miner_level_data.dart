enum MinerDifficultyTier {
  beginner,     // 11 - 29 (1-2 tens, 1-9 ones)
  intermediate, // 31 - 69 (3-6 tens, 1-9 ones)
  advanced,     // 70 - 99 (7-9 tens, 1-9 ones)
  master,       // Round tens e.g. 20, 40, 50, 80 (testing zero singles!)
}

class MinerLevelData {
  final int levelNumber;
  final int targetNumber;
  final MinerDifficultyTier tier;

  const MinerLevelData({
    required this.levelNumber,
    required this.targetNumber,
    required this.tier,
  });

  int get tensCount => targetNumber ~/ 10;
  int get singlesCount => targetNumber % 10;
  int get tensValue => tensCount * 10;

  /// Optimal swings needed to perfectly mine the crystal to 0
  int get optimalSwings => tensCount + singlesCount;
}
