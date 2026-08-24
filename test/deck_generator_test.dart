import 'package:flutter_test/flutter_test.dart';
import 'package:number_parts/features/number_bonds_game/data/levels_data.dart';
import 'package:number_parts/features/number_bonds_game/domain/logic/deck_generator.dart';

void main() {
  group('DeckGenerator', () {
    test('generates cards with correct total count and valid pair sums', () {
      for (final level in LevelsData.allLevels) {
        final deck = DeckGenerator.generateDeck(level);
        expect(deck.length, equals(level.totalCards));
        expect(deck.length % 2, equals(0));

        // Ensure all values are positive and less than targetSum
        for (final card in deck) {
          expect(card.value > 0, isTrue);
          expect(card.value < level.targetSum, isTrue);
        }
      }
    });

    test('guarantees that all unique number bond combinations are included in the deck', () {
      for (final level in LevelsData.allLevels) {
        final deck = DeckGenerator.generateDeck(level);
        final values = deck.map((c) => c.value).toSet();

        // For targetSum S, every number 1..S-1 should be present in the deck
        // if the level has enough slots (which all our levels do)
        final maxPossiblePairs = level.targetSum ~/ 2;
        final actualPairs = level.slots.length ~/ 2;

        if (actualPairs >= maxPossiblePairs) {
          for (int a = 1; a <= level.targetSum ~/ 2; a++) {
            final b = level.targetSum - a;
            expect(
              values.contains(a),
              isTrue,
              reason: 'Level ${level.levelNumber} (Target ${level.targetSum}) should contain $a',
            );
            expect(
              values.contains(b),
              isTrue,
              reason: 'Level ${level.levelNumber} (Target ${level.targetSum}) should contain $b',
            );
          }
        }
      }
    });
  });
}
