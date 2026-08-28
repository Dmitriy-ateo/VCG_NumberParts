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

  /// Simple: Numbers strictly up to 10, no transitions through the 10th.
  static _MathTask _generateSimpleTask(Random rng) {
    final isAddition = rng.nextBool();
    if (isAddition) {
      // a + b <= 10
      final sum = 3 + rng.nextInt(8); // 3..10
      final a = 1 + rng.nextInt(sum - 1); // 1..(sum-1)
      final b = sum - a;
      return _MathTask('$a + $b', sum);
    } else {
      // a - b >= 1 where a <= 10
      final a = 3 + rng.nextInt(8); // 3..10
      final b = 1 + rng.nextInt(a - 1); // 1..(a-1)
      final diff = a - b;
      return _MathTask('$a - $b', diff);
    }
  }

  /// Advanced: Basic + 2-digit numbers, NO transitions through the 10th (no carry, no borrow).
  static _MathTask _generateAdvancedTask(Random rng) {
    final isAddition = rng.nextBool();
    if (isAddition) {
      // 2-digit + 2-digit (or basic + 2-digit) without carry
      final aTens = 1 + rng.nextInt(5); // 1..5
      final aUnits = rng.nextInt(6); // 0..5
      final a = aTens * 10 + aUnits;

      final maxBTens = 8 - aTens;
      final bTens = rng.nextInt(maxBTens + 1); // 0..maxBTens
      final maxBUnits = 9 - aUnits;
      final bUnits = rng.nextInt(maxBUnits + 1); // 0..maxBUnits

      final b = bTens * 10 + bUnits;
      if (b == 0) {
        return _MathTask('$a + 3', a + 3);
      }
      return _MathTask('$a + $b', a + b);
    } else {
      // 2-digit subtraction without borrow
      final aTens = 2 + rng.nextInt(7); // 2..8
      final aUnits = 1 + rng.nextInt(9); // 1..9
      final a = aTens * 10 + aUnits;

      final bTens = rng.nextInt(aTens); // 0..(aTens-1)
      final bUnits = rng.nextInt(aUnits + 1); // 0..aUnits (bUnits <= aUnits)
      final b = bTens * 10 + bUnits;

      if (b == 0) {
        return _MathTask('$a - 1', a - 1);
      }
      return _MathTask('$a - $b', a - b);
    }
  }

  /// Hard: 2-digit numbers, WITH OR WITHOUT transitions through the 10th.
  static _MathTask _generateHardTask(Random rng) {
    final isAddition = rng.nextBool();
    final withTransition = rng.nextBool();

    if (isAddition) {
      if (withTransition) {
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
        return _generateAdvancedTask(rng);
      }
    } else {
      if (withTransition) {
        // 2-digit subtraction WITH borrowing
        final aTens = 3 + rng.nextInt(5); // 3..7
        final aUnits = rng.nextInt(7); // 0..6
        final a = aTens * 10 + aUnits;

        final bTens = 1 + rng.nextInt(aTens - 1); // 1..(aTens-1)
        final minBUnits = aUnits + 1;
        final bUnits = minBUnits + rng.nextInt(10 - minBUnits); // bUnits > aUnits
        final b = bTens * 10 + bUnits;

        return _MathTask('$a - $b', a - b);
      } else {
        return _generateAdvancedTask(rng);
      }
    }
  }

  static List<int> _generateDistractors({
    required int correctAnswer,
    required LabyrinthDifficulty difficulty,
    required int count,
    required Random rng,
  }) {
    final Set<int> distractors = {};

    if (difficulty == LabyrinthDifficulty.simple) {
      // Simple distractors must also be strictly in [1..10]
      final pool = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]..shuffle(rng);
      for (final val in pool) {
        if (val != correctAnswer) {
          distractors.add(val);
          if (distractors.length == count) break;
        }
      }
      return distractors.toList();
    }

    // Smart candidate pool based on pedagogical math slips
    final deltas = [1, -1, 2, -2, 10, -10, 3, -3, 5, -5]..shuffle(rng);

    for (final d in deltas) {
      final candidate = correctAnswer + d;
      if (candidate >= 10 && candidate <= 99 && candidate != correctAnswer) {
        distractors.add(candidate);
        if (distractors.length == count) break;
      }
    }

    // Fallback if needed
    int offset = 4;
    while (distractors.length < count) {
      final candidate = (correctAnswer + offset).clamp(10, 99);
      if (candidate != correctAnswer && !distractors.contains(candidate)) {
        distractors.add(candidate);
      }
      offset++;
    }

    return distractors.toList();
  }
}

class _MathTask {
  final String equation;
  final int answer;

  const _MathTask(this.equation, this.answer);
}
