class LabyrinthChamber {
  final int chamberIndex; // 0-indexed (e.g. 0 to 4 for a 5-chamber level)
  final String equation; // e.g. "15 + 17"
  final int correctAnswer; // e.g. 32
  final List<int> doorOptions; // shuffled candidate answers, e.g. [22, 32, 31]

  const LabyrinthChamber({
    required this.chamberIndex,
    required this.equation,
    required this.correctAnswer,
    required this.doorOptions,
  });
}
