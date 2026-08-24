import 'package:flutter/foundation.dart';
import '../../../../core/storage/progress_repository.dart';
import '../../data/levels_data.dart';
import '../../domain/logic/deck_generator.dart';
import '../../domain/logic/overlap_engine.dart';
import '../../domain/models/card_node.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/level_data.dart';

class GameController extends ChangeNotifier {
  final ProgressRepository _progressRepository = ProgressRepository();
  
  GameState _state;
  GameState get state => _state;

  GameController(LevelData initialLevel)
      : _state = GameState(
          level: initialLevel,
          cards: DeckGenerator.generateDeck(initialLevel),
        );

  void startLevel(LevelData level) {
    final generated = DeckGenerator.generateDeck(level);
    _state = GameState(
      level: level,
      cards: generated,
      lives: 3,
      maxLives: 3,
      selectedCardIds: const [],
      isWon: false,
      isGameOver: false,
      hintsRemaining: 3,
      undoStack: const [],
      movesCount: 0,
      mistakesCount: 0,
    );
    notifyListeners();
  }

  void restart() {
    startLevel(_state.level);
  }

  void nextLevel() {
    final nextNum = _state.level.levelNumber + 1;
    final nextLvl = LevelsData.getLevel(nextNum);
    startLevel(nextLvl);
  }

  Future<void> onCardTapped(String cardId) async {
    if (_state.isWon || _state.isGameOver) return;

    final card = _state.cards.firstWhere((c) => c.id == cardId);
    if (card.isMatched || card.isBlocked) return;

    final selected = List<String>.from(_state.selectedCardIds);

    // If tapping the already selected card, deselect it
    if (selected.contains(cardId)) {
      selected.remove(cardId);
      _updateCardSelection(selected);
      return;
    }

    // First card selection
    if (selected.isEmpty) {
      selected.add(cardId);
      _updateCardSelection(selected);
      return;
    }

    // Second card selection -> Evaluate Match
    final firstCardId = selected.first;
    final firstCard = _state.cards.firstWhere((c) => c.id == firstCardId);
    final target = _state.level.targetSum;

    if (firstCard.value + card.value == target) {
      // ✅ VALID MATCH
      final snapshot = List<CardNode>.from(_state.cards);
      final newUndoStack = List<List<CardNode>>.from(_state.undoStack)..add(snapshot);

      final updatedCards = _state.cards.map((c) {
        if (c.id == firstCardId || c.id == cardId) {
          return c.copyWith(
            isMatched: true,
            isSelected: false,
            isHinted: false,
          );
        }
        return c.copyWith(isHinted: false);
      }).toList();

      final recomputed = OverlapEngine.updateBlockedStates(updatedCards);
      final remaining = recomputed.where((c) => !c.isMatched).length;
      final isWon = remaining == 0;

      _state = _state.copyWith(
        cards: recomputed,
        selectedCardIds: const [],
        undoStack: newUndoStack,
        movesCount: _state.movesCount + 1,
        isWon: isWon,
      );
      notifyListeners();

      if (isWon) {
        final stars = _state.calculatedStars;
        await _progressRepository.saveStarsForLevel(_state.level.levelNumber, stars);
        await _progressRepository.unlockLevel(_state.level.levelNumber + 1);
      }
    } else {
      // ❌ MISMATCH (Lose 1 Life)
      final newLives = _state.lives - 1;
      final newMistakes = _state.mistakesCount + 1;
      final isGameOver = newLives <= 0;

      _state = _state.copyWith(
        lives: newLives,
        mistakesCount: newMistakes,
        selectedCardIds: const [],
        isGameOver: isGameOver,
      );
      _updateCardSelection(const []);
    }
  }

  void _updateCardSelection(List<String> selectedIds) {
    final updated = _state.cards.map((c) {
      final isSel = selectedIds.contains(c.id);
      return c.copyWith(isSelected: isSel);
    }).toList();

    _state = _state.copyWith(
      cards: updated,
      selectedCardIds: selectedIds,
    );
    notifyListeners();
  }

  void useHint() {
    if (_state.hintsRemaining <= 0 || _state.isWon || _state.isGameOver) return;

    final match = OverlapEngine.findAvailableMatch(_state.cards, _state.level.targetSum);
    if (match == null || match.length < 2) return;

    final hintIds = [match[0].id, match[1].id];
    final updated = _state.cards.map((c) {
      if (hintIds.contains(c.id)) {
        return c.copyWith(isHinted: true);
      }
      return c;
    }).toList();

    _state = _state.copyWith(
      cards: updated,
      hintsRemaining: _state.hintsRemaining - 1,
    );
    notifyListeners();
  }

  void undo() {
    if (_state.undoStack.isEmpty || _state.isWon || _state.isGameOver) return;

    final newUndoStack = List<List<CardNode>>.from(_state.undoStack);
    final previousCards = newUndoStack.removeLast();

    _state = _state.copyWith(
      cards: previousCards,
      selectedCardIds: const [],
      undoStack: newUndoStack,
    );
    notifyListeners();
  }
}
