import 'dart:math';
import '../models/labyrinth_chamber.dart';
import '../models/labyrinth_difficulty.dart';

class LabyrinthTaskGenerator {
  static final Random _defaultRng = Random();

  /// Generates a randomized chamber task with smart distractors based on difficulty.
  static LabyrinthChamber generateChamber({
    required LabyrinthDifficulty difficulty,
    required int chamberIndex,
    int doorsCount = 3,
    Random? rng,
  }) {
    final random = rng ?? _defaultRng;

    String equation;
    int correctAnswer;

    switch (difficulty) {
      case LabyrinthDifficulty.simple:
        final task = _generateSimpleTask(random);
        equation = task.equation;
        correctAnswer = task.answer;
        break;

      case LabyrinthDifficulty.advanced:
        final task = _generateAdvancedTask(random);
        equation = task.equation;
        correctAnswer = task.answer;
        break;

      case LabyrinthDifficulty.hard:
        final task = _generateHardTask(random);
        equation = task.equation;
        correctAnswer = task.answer;
        break;
    }

    final distractors = _generateDistractors(
      correctAnswer: correctAnswer,
      difficulty: difficulty,
      count: doorsCount - 1,
      rng: random,
    );

    final doorOptions = [correctAnswer, ...distractors]..shuffle(random);

    return LabyrinthChamber(
      chamberIndex: chamberIndex,
      equation: equation,
      correctAnswer: correctAnswer,
      doorOptions: doorOptions,
    );
  }

  static _MathTask _generateSimpleTask(Random rng) {
    final isAddition = rng.nextBool();
    if (isAddition) {
      // Single digits crossing 10 (sum 11..18)
      final a = 2 + rng.nextInt(8); // 2..9
      final minB = max(2, 11 - a);
      final maxB = 9;
      final b = minB + rng.nextInt(maxB - minB + 1);
      return _MathTask('$a + $b', a + b);
    } else {
      // Subtraction crossing 10 (11..18 minus single digit resulting in 2..9)
      final a = 11 + rng.nextInt(8); // 11..18
      final minB = a - 9;
      final maxB = min(9, a - 2);
      final b = minB + rng.nextInt(maxB - minB + 1);
      return _MathTask('$a - $b', a - b);
    }
  }

  static _MathTask _generateAdvancedTask(Random rng) {
    final taskType = rng.nextInt(3);
    if (taskType == 0) {
      // 2-digit + 2-digit without carry
      final aTens = 1 + rng.nextInt(3); // 1..3
      final aUnits = 1 + rng.nextInt(5); // 1..5
      final a = aTens * 10 + aUnits;

      final bTens = 1 + rng.nextInt(3); // 1..3
      final bUnits = 1 + rng.nextInt(9 - aUnits); // sum of units <= 9
      final b = bTens * 10 + bUnits;

      return _MathTask('$a + $b', a + b);
    } else if (taskType == 1) {
      // 2-digit subtraction without borrow
      final aTens = 2 + rng.nextInt(4); // 2..5
      final aUnits = 2 + rng.nextInt(8); // 2..9
      final a = aTens * 10 + aUnits;

      final bTens = 1 + rng.nextInt(aTens); // 1..aTens
      final bUnits = rng.nextInt(aUnits + 1); // 0..aUnits
      final b = bTens * 10 + bUnits;

      return _MathTask('$a - $b', a - b);
    } else {
      // Basic multiplication fact
      final a = 2 + rng.nextInt(4); // 2..5
      final b = 3 + rng.nextInt(7); // 3..9
      return _MathTask('$a × $b', a * b);
    }
  }

  static _MathTask _generateHardTask(Random rng) {
    final isAddition = rng.nextBool();
    if (isAddition) {
      // 2-digit + 2-digit WITH carry over the 10
      final aTens = 1 + rng.nextInt(4); // 1..4
      final aUnits = 4 + rng.nextInt(6); // 4..9
      final a = aTens * 10 + aUnits;

      final bTens = 1 + rng.nextInt(4); // 1..4
      final minBUnits = 10 - aUnits;
      final bUnits = minBUnits + rng.nextInt(10 - minBUnits); // units sum >= 10
      final b = bTens * 10 + bUnits;

      return _MathTask('$a + $b', a + b);
    } else {
      // 2-digit subtraction WITH borrowing
      final aTens = 3 + rng.nextInt(5); // 3..7
      final aUnits = rng.nextInt(7); // 0..6
      final a = aTens * 10 + aUnits;

      final bTens = 1 + rng.nextInt(aTens - 1); // 1..(aTens-1)
      final minBUnits = aUnits + 1;
      final bUnits = minBUnits + rng.nextInt(10 - minBUnits); // bUnits > aUnits
      final b = bTens * 10 + bUnits;

      return _MathTask('$a - $b', a - b);
    }
  }

  static List<int> _generateDistractors({
    required int correctAnswer,
    required LabyrinthDifficulty difficulty,
    required int count,
    required Random rng,
  }) {
    final Set<int> distractors = {};

    // Smart candidate pool based on pedagogical math slips
    final List<int> candidates = [];

    // 1. Off-by-one slips
    candidates.add(correctAnswer + 1);
    candidates.add(correctAnswer - 1);

    // 2. Off-by-two slips
    candidates.add(correctAnswer + 2);
    candidates.add(correctAnswer - 2);

    // 3. Off-by-ten slips (very common in 2-digit arithmetic)
    if (correctAnswer > 10) candidates.add(correctAnswer - 10);
    candidates.add(correctAnswer + 10);

    // 4. In Hard mode: carry omission/extra carry
    if (difficulty == LabyrinthDifficulty.hard) {
      if (correctAnswer > 10) candidates.add(correctAnswer - 10);
      candidates.add(correctAnswer + 9);
      candidates.add(correctAnswer - 9);
    }

    candidates.shuffle(rng);

    for (final candidate in candidates) {
      if (candidate > 0 && candidate != correctAnswer) {
        distractors.add(candidate);
        if (distractors.length == count) break;
      }
    }

    // Fallback if needed
    int delta = 3;
    while (distractors.length < count) {
      final cand = correctAnswer + (rng.nextBool() ? delta : -delta);
      if (cand > 0 && cand != correctAnswer) {
        distractors.add(cand);
      }
      delta++;
    }

    return distractors.toList();
  }
}

class _MathTask {
  final String equation;
  final int answer;
  const _MathTask(this.equation, this.answer);
}
