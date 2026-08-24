import 'package:flutter_test/flutter_test.dart';
import 'package:number_parts/features/number_bonds_game/domain/logic/overlap_engine.dart';
import 'package:number_parts/features/number_bonds_game/domain/models/card_node.dart';

void main() {
  group('OverlapEngine', () {
    test('detects when higher layer card overlaps and blocks lower layer card', () {
      const bottom = CardNode(
        id: 'bot',
        value: 3,
        x: 0.0,
        y: 0.0,
        width: 1.0,
        height: 1.2,
        layer: 0,
      );

      const top = CardNode(
        id: 'top',
        value: 7,
        x: 0.5,
        y: 0.5,
        width: 1.0,
        height: 1.2,
        layer: 1,
      );

      expect(OverlapEngine.blocks(top, bottom), isTrue);
      expect(OverlapEngine.blocks(bottom, top), isFalse); // lower cannot block higher
    });

    test('recalculates blocked state when top card is matched', () {
      const bottom = CardNode(
        id: 'bot',
        value: 3,
        x: 0.0,
        y: 0.0,
        width: 1.0,
        height: 1.2,
        layer: 0,
      );

      const top = CardNode(
        id: 'top',
        value: 7,
        x: 0.5,
        y: 0.5,
        width: 1.0,
        height: 1.2,
        layer: 1,
      );

      final initial = OverlapEngine.updateBlockedStates([bottom, top]);
      expect(initial.firstWhere((c) => c.id == 'bot').isBlocked, isTrue);
      expect(initial.firstWhere((c) => c.id == 'top').isBlocked, isFalse);

      // Now match top
      final matchedTop = top.copyWith(isMatched: true);
      final updated = OverlapEngine.updateBlockedStates([bottom, matchedTop]);
      expect(updated.firstWhere((c) => c.id == 'bot').isBlocked, isFalse);
    });
  });
}
