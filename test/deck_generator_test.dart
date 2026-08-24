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
  });
}
