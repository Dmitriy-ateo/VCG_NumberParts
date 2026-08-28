import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_parts/features/labyrinth_game/domain/logic/labyrinth_task_generator.dart';
import 'package:number_parts/features/labyrinth_game/domain/models/labyrinth_difficulty.dart';

void main() {
  group('LabyrinthTaskGenerator', () {
    final rng = Random(42);

    test('Simple difficulty generates arithmetic up to 10 with no transitions through 10', () {
      for (int i = 0; i < 50; i++) {
        final chamber = LabyrinthTaskGenerator.generateChamber(
          difficulty: LabyrinthDifficulty.simple,
          chamberIndex: i % 5,
          rng: rng,
        );

        expect(chamber.doorOptions.length, 3);
        expect(chamber.doorOptions.toSet().length, 3, reason: 'Options must be unique');
        expect(chamber.doorOptions.contains(chamber.correctAnswer), isTrue);
        expect(chamber.correctAnswer <= 10, isTrue);

        for (final opt in chamber.doorOptions) {
          expect(opt <= 10, isTrue);
          expect(opt >= 1, isTrue);
        }

        if (chamber.equation.contains('+')) {
          final parts = chamber.equation.split('+').map((s) => int.parse(s.trim())).toList();
          expect(parts[0] + parts[1], chamber.correctAnswer);
          expect(chamber.correctAnswer, lessThanOrEqualTo(10));
        } else {
          final parts = chamber.equation.split('-').map((s) => int.parse(s.trim())).toList();
          expect(parts[0] - parts[1], chamber.correctAnswer);
          expect(parts[0], lessThanOrEqualTo(10));
        }
      }
    });

    test('Advanced difficulty generates valid 2-digit addition and subtraction without carry/borrow', () {
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
          expect((parts[0] % 10) + (parts[1] % 10), lessThan(10),
              reason: 'Advanced addition must not carry over 10');
        } else if (chamber.equation.contains('-')) {
          final parts = chamber.equation.split('-').map((s) => int.parse(s.trim())).toList();
          expect(parts[0] - parts[1], chamber.correctAnswer);
          expect(parts[0] % 10, greaterThanOrEqualTo(parts[1] % 10),
              reason: 'Advanced subtraction must not borrow');
        }
      }
    });

    test('Hard difficulty generates valid 2-digit arithmetic with or without regrouping/carry', () {
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
          expect(chamber.correctAnswer >= 10, isTrue);
        } else if (chamber.equation.contains('-')) {
          final parts = chamber.equation.split('-').map((s) => int.parse(s.trim())).toList();
          expect(parts[0] - parts[1], chamber.correctAnswer);
          expect(parts[0] >= 10, isTrue);
        }
      }
    });
  });
}
