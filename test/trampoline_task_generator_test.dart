import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_parts/features/trampoline_game/domain/logic/trampoline_task_generator.dart';
import 'package:number_parts/features/trampoline_game/domain/models/trampoline_difficulty.dart';

void main() {
  group('TrampolineTaskGenerator Tests', () {
    final rng = Random(42);

    test('Generates 3 distinct trampolines with exactly 1 matching the target', () {
      for (final diff in TrampolineDifficulty.values) {
        for (int i = 0; i < 30; i++) {
          final round = TrampolineTaskGenerator.generateRound(difficulty: diff, rng: rng);

          expect(round.trampolines.length, 3);
          expect(round.trampolines.where((t) => t.isCorrect).length, 1);

          final correct = round.correctTrampoline;
          expect(correct.value, round.targetNumber);

          // Verify expression evaluates to the specified value
          for (final tramp in round.trampolines) {
            expect(tramp.expression.contains('×'), isFalse, reason: 'No multiplication allowed');
            if (tramp.expression.contains('+')) {
              final parts = tramp.expression.split('+').map((s) => int.parse(s.trim())).toList();
              expect(parts[0] + parts[1], tramp.value);
            } else if (tramp.expression.contains('-')) {
              final parts = tramp.expression.split('-').map((s) => int.parse(s.trim())).toList();
              expect(parts[0] - parts[1], tramp.value);
            }
          }
        }
      }
    });
  });
}
