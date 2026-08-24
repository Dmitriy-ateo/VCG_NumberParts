import '../models/card_node.dart';

class OverlapEngine {
  static const double _overlapEpsilon = 0.15; // Requires significant overlap to block

  /// Checks if card [top] rests on top of and blocks card [bottom].
  static bool blocks(CardNode top, CardNode bottom) {
    if (top.isMatched || bottom.isMatched) return false;
    if (top.layer <= bottom.layer) return false;

    final topLeft = top.x;
    final topRight = top.x + top.width;
    final topTop = top.y;
    final topBottom = top.y + top.height;

    final botLeft = bottom.x;
    final botRight = bottom.x + bottom.width;
    final botTop = bottom.y;
    final botBottom = bottom.y + bottom.height;

    final xOverlap = (topRight - _overlapEpsilon > botLeft) &&
        (topLeft + _overlapEpsilon < botRight);
    final yOverlap = (topBottom - _overlapEpsilon > botTop) &&
        (topTop + _overlapEpsilon < botBottom);

    return xOverlap && yOverlap;
  }

  /// Recalculates `isBlocked` for every card in the deck based on higher-layer cards.
  static List<CardNode> updateBlockedStates(List<CardNode> cards) {
    final activeCards = cards.where((c) => !c.isMatched).toList();

    return cards.map((card) {
      if (card.isMatched) {
        return card.copyWith(isBlocked: false);
      }

      final isBlocked = activeCards.any((other) => blocks(other, card));
      return card.copyWith(isBlocked: isBlocked);
    }).toList();
  }

  /// Finds all currently free (unblocked and unmatched) cards.
  static List<CardNode> getFreeCards(List<CardNode> cards) {
    return cards.where((c) => !c.isMatched && !c.isBlocked).toList();
  }

  /// Finds an available valid matching pair among currently free cards.
  static List<CardNode>? findAvailableMatch(List<CardNode> cards, int targetSum) {
    final free = getFreeCards(cards);
    for (int i = 0; i < free.length; i++) {
      for (int j = i + 1; j < free.length; j++) {
        if (free[i].value + free[j].value == targetSum) {
          return [free[i], free[j]];
        }
      }
    }
    return null;
  }
}
