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

    // 3. Generate expressions for distractors
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

  static _MathExpression _generateSimpleExpression(Random rng) {
    final isAddition = rng.nextBool();
    if (isAddition) {
      // Sum between 11 and 18 (crossing 10)
      final a = 3 + rng.nextInt(7); // 3..9
      final minB = max(2, 11 - a);
      final maxB = 9;
      final b = minB + rng.nextInt(maxB - minB + 1);
      return _MathExpression('$a + $b', a + b);
    } else {
      // Subtraction from 11..18 down to 2..9
      final a = 11 + rng.nextInt(8); // 11..18
      final minB = a - 9;
      final maxB = min(9, a - 2);
      final b = minB + rng.nextInt(maxB - minB + 1);
      return _MathExpression('$a - $b', a - b);
    }
  }

  static _MathExpression _generateAdvancedExpression(Random rng) {
    final isAddition = rng.nextBool();
    if (isAddition) {
      // 2-digit without carry
      final aTens = 1 + rng.nextInt(4); // 1..4
      final aUnits = 1 + rng.nextInt(5); // 1..5
      final a = aTens * 10 + aUnits;

      final bTens = 1 + rng.nextInt(4); // 1..4
      final bUnits = 1 + rng.nextInt(9 - aUnits);
      final b = bTens * 10 + bUnits;

      return _MathExpression('$a + $b', a + b);
    } else {
      // 2-digit subtraction without borrow
      final aTens = 2 + rng.nextInt(5); // 2..6
      final aUnits = 2 + rng.nextInt(8); // 2..9
      final a = aTens * 10 + aUnits;

      final bTens = 1 + (aTens > 1 ? rng.nextInt(aTens) : 0);
      final bUnits = rng.nextInt(aUnits + 1);
      final b = bTens * 10 + bUnits;

      return _MathExpression('$a - $b', a - b);
    }
  }

  static _MathExpression _generateHardExpression(Random rng) {
    final isAddition = rng.nextBool();
    if (isAddition) {
      // 2-digit WITH carry over 10
      final aTens = 1 + rng.nextInt(4); // 1..4
      final aUnits = 4 + rng.nextInt(6); // 4..9
      final a = aTens * 10 + aUnits;

      final bTens = 1 + rng.nextInt(4); // 1..4
      final minBUnits = 10 - aUnits; // in 1..6
      final bUnits = minBUnits + rng.nextInt(10 - minBUnits); // minBUnits..9
      final b = bTens * 10 + bUnits;

      return _MathExpression('$a + $b', a + b);
    } else {
      // 2-digit subtraction WITH borrow
      final aTens = 3 + rng.nextInt(4); // 3..6
      final aUnits = rng.nextInt(8); // 0..7
      final a = aTens * 10 + aUnits;

      final bTens = 1 + rng.nextInt(aTens - 1); // strictly < aTens
      final minBUnits = aUnits + 1; // 1..8
      final bUnits = minBUnits + rng.nextInt(10 - minBUnits); // minBUnits..9
      final b = bTens * 10 + bUnits;

      return _MathExpression('$a - $b', a - b);
    }
  }

  static Set<int> _generateDistractorValues(
    int target,
    TrampolineDifficulty difficulty,
    Random rng,
  ) {
    final distractors = <int>{};
    final deltas = [1, -1, 2, -2, 10, -10, 3, -3, 5, -5]..shuffle(rng);

    for (final d in deltas) {
      final val = target + d;
      if (val >= 2 && val != target) {
        distractors.add(val);
        if (distractors.length == 2) break;
      }
    }

    int fallbackOffset = 4;
    while (distractors.length < 2) {
      final val = target + fallbackOffset;
      if (val >= 2 && val != target && !distractors.contains(val)) {
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
    final isAddition = rng.nextBool();
    if (isAddition && value >= 4) {
      final minA = max(1, (value * 0.25).round());
      final maxA = max(minA, (value * 0.75).round());
      final a = minA + rng.nextInt(maxA - minA + 1);
      final b = value - a;
      return _MathExpression('$a + $b', value);
    } else {
      final extra = 2 + rng.nextInt(8);
      final a = value + extra;
      final b = extra;
      return _MathExpression('$a - $b', value);
    }
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
