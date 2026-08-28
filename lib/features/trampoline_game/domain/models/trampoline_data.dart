class TrampolineData {
  final int index;
  final String expression;
  final int value;
  final bool isCorrect;

  const TrampolineData({
    required this.index,
    required this.expression,
    required this.value,
    required this.isCorrect,
  });
}

class TrampolineRoundTask {
  final int targetNumber;
  final List<TrampolineData> trampolines;

  const TrampolineRoundTask({
    required this.targetNumber,
    required this.trampolines,
  });

  TrampolineData get correctTrampoline =>
      trampolines.firstWhere((t) => t.isCorrect);
}
