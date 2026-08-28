import 'dart:math';
import '../models/trampoline_data.dart';
import '../models/trampoline_difficulty.dart';

class TrampolineTaskGenerator {
  static TrampolineRoundTask generateRound({
    required TrampolineDifficulty difficulty,
    Random? rng,
  }) {
    final random = rng ?? Random();

    // 1. Generate target equation & target value
    final targetTask = _generateExpressionForDifficulty(difficulty, random);
    final targetNumber = targetTask.value;

    // 2. Generate 2 plausible distractor values and expressions
    final distractorValues = _generateDistractorValues(targetNumber, difficulty, random);

    // 3. Generate expressions for distractors matching the difficulty level
    final distractorTasks = distractorValues.map((val) {
      return _generateExpressionForValue(val, difficulty, random);
    }).toList();

    // 4. Assemble 3 trampolines and shuffle positions
    final allItems = [
      _ExpressionItem(targetTask.expression, targetTask.value, isCorrect: true),
      _ExpressionItem(distractorTasks[0].expression, distractorTasks[0].value, isCorrect: false),
      _ExpressionItem(distractorTasks[1].expression, distractorTasks[1].value, isCorrect: false),
    ]..shuffle(random);

    final trampolines = List.generate(3, (i) {
      return TrampolineData(
        index: i,
        expression: allItems[i].expression,
        value: allItems[i].value,
        isCorrect: allItems[i].isCorrect,
      );
    });

    return TrampolineRoundTask(
      targetNumber: targetNumber,
      trampolines: trampolines,
    );
  }

  static _MathExpression _generateExpressionForDifficulty(
    TrampolineDifficulty difficulty,
    Random rng,
  ) {
    switch (difficulty) {
      case TrampolineDifficulty.simple:
        return _generateSimpleExpression(rng);
      case TrampolineDifficulty.advanced:
        return _generateAdvancedExpression(rng);
      case TrampolineDifficulty.hard:
        return _generateHardExpression(rng);
    }
  }

  /// Simple: Numbers strictly up to 10, no transitions through the 10th.
  static _MathExpression _generateSimpleExpression(Random rng) {
    final isAddition = rng.nextBool();
    if (isAddition) {
      // a + b <= 10 (target between 3 and 10)
      final sum = 3 + rng.nextInt(8); // 3..10
      final a = 1 + rng.nextInt(sum - 1); // 1..(sum-1)
      final b = sum - a;
      return _MathExpression('$a + $b', sum);
    } else {
      // a - b >= 1 where a <= 10
      final a = 3 + rng.nextInt(8); // 3..10
      final b = 1 + rng.nextInt(a - 1); // 1..(a-1)
      final diff = a - b;
      return _MathExpression('$a - $b', diff);
    }
  }

  /// Advanced: Basic + 2-digit numbers, NO transitions through the 10th (no carry, no borrow).
  static _MathExpression _generateAdvancedExpression(Random rng) {
    final isAddition = rng.nextBool();
    if (isAddition) {
      // 2-digit addition without carrying: units sum <= 9, tens sum <= 9
      final aTens = 1 + rng.nextInt(5); // 1..5
      final aUnits = rng.nextInt(6); // 0..5
      final a = aTens * 10 + aUnits;

      final maxBTens = 8 - aTens;
      final bTens = rng.nextInt(maxBTens + 1); // 0..maxBTens
      final maxBUnits = 9 - aUnits;
      final bUnits = rng.nextInt(maxBUnits + 1); // 0..maxBUnits

      final b = bTens * 10 + bUnits;
      if (b == 0) {
        return _MathExpression('$a + 3', a + 3);
      }
      return _MathExpression('$a + $b', a + b);
    } else {
      // 2-digit subtraction without borrowing: aTens >= bTens, aUnits >= bUnits
      final aTens = 2 + rng.nextInt(7); // 2..8
      final aUnits = 1 + rng.nextInt(9); // 1..9
      final a = aTens * 10 + aUnits;

      final bTens = rng.nextInt(aTens); // 0..(aTens-1)
      final bUnits = rng.nextInt(aUnits + 1); // 0..aUnits
      final b = bTens * 10 + bUnits;

      if (b == 0) {
        return _MathExpression('$a - 1', a - 1);
      }
      return _MathExpression('$a - $b', a - b);
    }
  }

  /// Hard: 2-digit numbers, WITH OR WITHOUT transitions through the 10th.
  static _MathExpression _generateHardExpression(Random rng) {
    final isAddition = rng.nextBool();
    final withTransition = rng.nextBool();

    if (isAddition) {
      if (withTransition) {
        // Addition WITH carry over 10: units sum >= 10
        final aTens = 1 + rng.nextInt(4); // 1..4
        final aUnits = 4 + rng.nextInt(6); // 4..9
        final a = aTens * 10 + aUnits;

        final bTens = 1 + rng.nextInt(4); // 1..4
        final minBUnits = 10 - aUnits; // in 1..6
        final bUnits = minBUnits + rng.nextInt(10 - minBUnits); // minBUnits..9
        final b = bTens * 10 + bUnits;

        return _MathExpression('$a + $b', a + b);
      } else {
        // Standard 2-digit addition
        return _generateAdvancedExpression(rng);
      }
    } else {
      if (withTransition) {
        // Subtraction WITH borrow: aUnits < bUnits
        final aTens = 3 + rng.nextInt(5); // 3..7
        final aUnits = rng.nextInt(7); // 0..6
        final a = aTens * 10 + aUnits;

        final bTens = 1 + rng.nextInt(aTens - 1); // strictly < aTens
        final minBUnits = aUnits + 1; // 1..7
        final bUnits = minBUnits + rng.nextInt(10 - minBUnits); // minBUnits..9
        final b = bTens * 10 + bUnits;

        return _MathExpression('$a - $b', a - b);
      } else {
        // Standard 2-digit subtraction
        return _generateAdvancedExpression(rng);
      }
    }
  }

  static Set<int> _generateDistractorValues(
    int target,
    TrampolineDifficulty difficulty,
    Random rng,
  ) {
    final distractors = <int>{};

    if (difficulty == TrampolineDifficulty.simple) {
      // Simple distractors must also be strictly in [2..10]
      final pool = [2, 3, 4, 5, 6, 7, 8, 9, 10]..shuffle(rng);
      for (final val in pool) {
        if (val != target) {
          distractors.add(val);
          if (distractors.length == 2) break;
        }
      }
      return distractors;
    }

    // Advanced & Hard: smart plausible offsets
    final deltas = [1, -1, 2, -2, 10, -10, 3, -3, 5, -5]..shuffle(rng);
    for (final d in deltas) {
      final val = target + d;
      if (val >= 10 && val <= 99 && val != target) {
        distractors.add(val);
        if (distractors.length == 2) break;
      }
    }

    int fallbackOffset = 4;
    while (distractors.length < 2) {
      final val = (target + fallbackOffset).clamp(10, 99);
      if (val != target && !distractors.contains(val)) {
        distractors.add(val);
      }
      fallbackOffset++;
    }

    return distractors;
  }

  static _MathExpression _generateExpressionForValue(
    int value,
    TrampolineDifficulty difficulty,
    Random rng,
  ) {
    if (difficulty == TrampolineDifficulty.simple) {
      // Value is in [2..10]. Generate equation in [1..10]
      final isAddition = rng.nextBool();
      if (isAddition && value >= 2) {
        final a = 1 + rng.nextInt(value - 1);
        final b = value - a;
        return _MathExpression('$a + $b', value);
      } else {
        final maxExtra = 10 - value;
        final extra = maxExtra > 0 ? 1 + rng.nextInt(maxExtra) : 0;
        final a = value + extra;
        final b = extra;
        if (b == 0) return _MathExpression('$value + 0', value);
        return _MathExpression('$a - $b', value);
      }
    }

    // Advanced / Hard: Generate matching 2-digit expression
    final isAddition = rng.nextBool();
    if (isAddition && value >= 15) {
      final valTens = value ~/ 10;
      final valUnits = value % 10;

      final aTens = valTens > 1 ? 1 + rng.nextInt(valTens) : 1;
      final bTens = valTens - aTens;

      final aUnits = rng.nextInt(valUnits + 1);
      final bUnits = valUnits - aUnits;

      final a = aTens * 10 + aUnits;
      final b = bTens * 10 + bUnits;
      if (a > 0 && b > 0) {
        return _MathExpression('$a + $b', value);
      }
    }

    // Subtraction fallback
    final extraTens = 1 + rng.nextInt(3);
    final a = value + (extraTens * 10);
    final b = extraTens * 10;
    return _MathExpression('$a - $b', value);
  }
}

class _MathExpression {
  final String expression;
  final int value;

  const _MathExpression(this.expression, this.value);
}

class _ExpressionItem {
  final String expression;
  final int value;
  final bool isCorrect;

  const _ExpressionItem(this.expression, this.value, {required this.isCorrect});
}
