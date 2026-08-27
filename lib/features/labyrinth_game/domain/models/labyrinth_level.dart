import 'labyrinth_difficulty.dart';

class LabyrinthLevel {
  final int levelNumber;
  final LabyrinthDifficulty difficulty;
  final int chambersCount;
  final String title;

  const LabyrinthLevel({
    required this.levelNumber,
    required this.difficulty,
    this.chambersCount = 5,
    required this.title,
  });
}
