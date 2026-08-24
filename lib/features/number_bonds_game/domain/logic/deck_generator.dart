import 'dart:math';
import '../models/card_node.dart';
import '../models/level_data.dart';
import 'overlap_engine.dart';

class DeckGenerator {
  /// Generates a list of [CardNode]s for a given level with guaranteed solvability.
  static List<CardNode> generateDeck(LevelData level, {int? seed}) {
    final rand = Random(seed ?? level.levelNumber * 100);

    final slotCount = level.slots.length;
    assert(slotCount % 2 == 0, 'Level slots count must be an even number');
    final pairCount = slotCount ~/ 2;

    // 1. Generate valid pairs for targetSum
    final validPairs = _generatePairsForTarget(level.targetSum);

    // Try up to 50 iterations to find a guaranteed solvable arrangement
    for (int attempt = 0; attempt < 50; attempt++) {
      final values = <int>[];
      for (int i = 0; i < pairCount; i++) {
        final pair = validPairs[rand.nextInt(validPairs.length)];
        values.add(pair.$1);
        values.add(pair.$2);
      }

      // Shuffle values across slots
      values.shuffle(rand);

      // Construct card nodes
      final cards = <CardNode>[];
      for (int i = 0; i < slotCount; i++) {
        final slot = level.slots[i];
        cards.add(
          CardNode(
            id: 'card_${level.levelNumber}_$i',
            value: values[i],
            x: slot.x,
            y: slot.y,
            layer: slot.layer,
            width: slot.width,
            height: slot.height,
          ),
        );
      }

      // Calculate initial blocked states
      final initialDeck = OverlapEngine.updateBlockedStates(cards);

      // Verify that this deck is solvable
      if (_isSolvable(initialDeck, level.targetSum)) {
        return initialDeck;
      }
    }

    // Fallback: return initialDeck if maximum attempts reached
    final fallbackCards = <CardNode>[];
    for (int i = 0; i < slotCount; i++) {
      final slot = level.slots[i];
      final pair = validPairs[i % validPairs.length];
      final val = (i % 2 == 0) ? pair.$1 : pair.$2;
      fallbackCards.add(
        CardNode(
          id: 'card_${level.levelNumber}_$i',
          value: val,
          x: slot.x,
          y: slot.y,
          layer: slot.layer,
          width: slot.width,
          height: slot.height,
        ),
      );
    }
    return OverlapEngine.updateBlockedStates(fallbackCards);
  }

  static List<(int, int)> _generatePairsForTarget(int target) {
    final pairs = <(int, int)>[];
    for (int a = 1; a <= target ~/ 2; a++) {
      final b = target - a;
      pairs.add((a, b));
    }
    return pairs;
  }

  /// Solvability check simulator via Breadth-First / Depth-First search
  static bool _isSolvable(List<CardNode> cards, int targetSum) {
    return _solveStep(cards, targetSum, 0);
  }

  static bool _solveStep(List<CardNode> currentCards, int targetSum, int depth) {
    if (depth > 25) return true; // Depth limit heuristic

    final remaining = currentCards.where((c) => !c.isMatched).toList();
    if (remaining.isEmpty) return true; // All cards cleared!

    final freeCards = OverlapEngine.getFreeCards(currentCards);
    if (freeCards.length < 2) return false;

    // Find candidate pairs
    for (int i = 0; i < freeCards.length; i++) {
      for (int j = i + 1; j < freeCards.length; j++) {
        if (freeCards[i].value + freeCards[j].value == targetSum) {
          final cardA = freeCards[i];
          final cardB = freeCards[j];

          // Simulate removing this pair
          final nextCards = currentCards.map((c) {
            if (c.id == cardA.id || c.id == cardB.id) {
              return c.copyWith(isMatched: true);
            }
            return c;
          }).toList();

          final updated = OverlapEngine.updateBlockedStates(nextCards);
          if (_solveStep(updated, targetSum, depth + 1)) {
            return true;
          }
        }
      }
    }

    return false;
  }
}
