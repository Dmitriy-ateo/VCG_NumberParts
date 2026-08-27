import '../domain/models/labyrinth_difficulty.dart';
import '../domain/models/labyrinth_level.dart';

class LabyrinthLevelsData {
  static const int chambersPerLevel = 5;

  static List<LabyrinthLevel> getLevelsForDifficulty(LabyrinthDifficulty difficulty) {
    final count = 10; // 10 levels per mode
    final String prefix;
    switch (difficulty) {
      case LabyrinthDifficulty.simple:
        prefix = 'Room';
        break;
      case LabyrinthDifficulty.advanced:
        prefix = 'Chamber';
        break;
      case LabyrinthDifficulty.hard:
        prefix = 'Sanctum';
        break;
    }

    return List.generate(
      count,
      (i) => LabyrinthLevel(
        levelNumber: i + 1,
        difficulty: difficulty,
        chambersCount: chambersPerLevel,
        title: '$prefix ${i + 1}',
      ),
    );
  }
}
