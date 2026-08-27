import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_parts/features/labyrinth_game/domain/logic/labyrinth_task_generator.dart';
import 'package:number_parts/features/labyrinth_game/domain/models/labyrinth_difficulty.dart';

void main() {
  group('LabyrinthTaskGenerator', () {
    final rng = Random(42);

    test('Simple difficulty generates crossing 10 addition and teens subtraction', () {
      for (int i = 0; i < 50; i++) {
        final chamber = LabyrinthTaskGenerator.generateChamber(
          difficulty: LabyrinthDifficulty.simple,
          chamberIndex: i % 5,
          rng: rng,
        );

        expect(chamber.doorOptions.length, 3);
        expect(chamber.doorOptions.toSet().length, 3, reason: 'Options must be unique');
        expect(chamber.doorOptions.contains(chamber.correctAnswer), isTrue);

        if (chamber.equation.contains('+')) {
          final parts = chamber.equation.split('+').map((s) => int.parse(s.trim())).toList();
          expect(parts[0] + parts[1], chamber.correctAnswer);
          expect(chamber.correctAnswer, greaterThanOrEqualTo(11));
        } else {
          final parts = chamber.equation.split('-').map((s) => int.parse(s.trim())).toList();
          expect(parts[0] - parts[1], chamber.correctAnswer);
          expect(parts[0], greaterThanOrEqualTo(11));
        }
      }
    });

    test('Advanced difficulty generates valid 2-digit arithmetic or multiplication', () {
      for (int i = 0; i < 50; i++) {
        final chamber = LabyrinthTaskGenerator.generateChamber(
          difficulty: LabyrinthDifficulty.advanced,
          chamberIndex: i % 5,
          rng: rng,
        );

        expect(chamber.doorOptions.length, 3);
        expect(chamber.doorOptions.toSet().length, 3);
        expect(chamber.doorOptions.contains(chamber.correctAnswer), isTrue);

        if (chamber.equation.contains('+')) {
          final parts = chamber.equation.split('+').map((s) => int.parse(s.trim())).toList();
          expect(parts[0] + parts[1], chamber.correctAnswer);
        } else if (chamber.equation.contains('-')) {
          final parts = chamber.equation.split('-').map((s) => int.parse(s.trim())).toList();
          expect(parts[0] - parts[1], chamber.correctAnswer);
        } else if (chamber.equation.contains('×')) {
          final parts = chamber.equation.split('×').map((s) => int.parse(s.trim())).toList();
          expect(parts[0] * parts[1], chamber.correctAnswer);
        }
      }
    });

    test('Hard difficulty generates valid 2-digit arithmetic with regrouping/carry', () {
      for (int i = 0; i < 50; i++) {
        final chamber = LabyrinthTaskGenerator.generateChamber(
          difficulty: LabyrinthDifficulty.hard,
          chamberIndex: i % 5,
          rng: rng,
        );

        expect(chamber.doorOptions.length, 3);
        expect(chamber.doorOptions.toSet().length, 3);
        expect(chamber.doorOptions.contains(chamber.correctAnswer), isTrue);

        if (chamber.equation.contains('+')) {
          final parts = chamber.equation.split('+').map((s) => int.parse(s.trim())).toList();
          expect(parts[0] + parts[1], chamber.correctAnswer);
          expect((parts[0] % 10) + (parts[1] % 10), greaterThanOrEqualTo(10),
              reason: 'Hard addition must carry over the ten');
        } else if (chamber.equation.contains('-')) {
          final parts = chamber.equation.split('-').map((s) => int.parse(s.trim())).toList();
          expect(parts[0] - parts[1], chamber.correctAnswer);
          expect(parts[0] % 10, lessThan(parts[1] % 10),
              reason: 'Hard subtraction must borrow over the ten');
        }
      }
    });
  });
}
