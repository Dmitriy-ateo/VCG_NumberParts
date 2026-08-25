import 'package:flutter/foundation.dart';
import '../../../../core/audio/sound_manager.dart';
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
    SoundManager.instance.playSwitchScreensSound();
    final nextNum = _state.level.levelNumber + 1;
    final nextLvl = LevelsData.getLevel(nextNum, _state.level.category);
    startLevel(nextLvl);
  }

  Future<void> onCardTapped(String cardId) async {
    if (_state.isWon || _state.isGameOver) return;

    final card = _state.cards.firstWhere((c) => c.id == cardId);
    if (card.isMatched || card.isBlocked || card.isClearing || card.isMismatched) return;

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
      // 1. Play sound
      SoundManager.instance.playMatchSound();

      final snapshot = List<CardNode>.from(_state.cards);
      final newUndoStack = List<List<CardNode>>.from(_state.undoStack)..add(snapshot);

      // 2. Mark cards as clearing for animation
      final clearingCards = _state.cards.map((c) {
        if (c.id == firstCardId || c.id == cardId) {
          return c.copyWith(
            isClearing: true,
            isSelected: false,
            isHinted: false,
          );
        }
        return c.copyWith(isHinted: false);
      }).toList();

      _state = _state.copyWith(
        cards: clearingCards,
        selectedCardIds: const [],
        undoStack: newUndoStack,
        movesCount: _state.movesCount + 1,
      );
      notifyListeners();

      // 3. Wait for golden pop and dissolve animation
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedCards = _state.cards.map((c) {
        if (c.id == firstCardId || c.id == cardId) {
          return c.copyWith(
            isMatched: true,
            isClearing: false,
            isSelected: false,
            isHinted: false,
          );
        }
        return c;
      }).toList();

      final recomputed = OverlapEngine.updateBlockedStates(updatedCards);
      final remaining = recomputed.where((c) => !c.isMatched).length;
      final isWon = remaining == 0;

      _state = _state.copyWith(
        cards: recomputed,
        isWon: isWon,
      );
      notifyListeners();

      if (isWon) {
        SoundManager.instance.playSuccessSound();
        await _progressRepository.saveStarsForLevel(
          _state.level.levelNumber,
          _state.calculatedStars,
          _state.level.category,
        );
        await _progressRepository.unlockLevel(
          _state.level.levelNumber + 1,
          _state.level.category,
        );
      }
    } else {
      // ❌ MISMATCH (Lose 1 Life)
      final newLives = _state.lives - 1;
      final newMistakes = _state.mistakesCount + 1;
      final isGameOver = newLives <= 0;

      // 1. Play audio
      if (isGameOver) {
        SoundManager.instance.playLoseSound();
      } else {
        SoundManager.instance.playWrongPickSound();
      }

      // 2. Mark mismatched cards for shake & red highlight
      final mismatchedCards = _state.cards.map((c) {
        if (c.id == firstCardId || c.id == cardId) {
          return c.copyWith(
            isMismatched: true,
            isSelected: false,
            isHinted: false,
          );
        }
        return c.copyWith(isHinted: false);
      }).toList();

      _state = _state.copyWith(
        cards: mismatchedCards,
        lives: newLives,
        mistakesCount: newMistakes,
        selectedCardIds: const [],
        isGameOver: isGameOver,
      );
      notifyListeners();

      // 3. Wait for shake animation to complete, then reset mismatch state
      await Future.delayed(const Duration(milliseconds: 400));

      final clearedMismatchCards = _state.cards.map((c) {
        if (c.id == firstCardId || c.id == cardId) {
          return c.copyWith(isMismatched: false);
        }
        return c;
      }).toList();

      _state = _state.copyWith(cards: clearedMismatchCards);
      notifyListeners();
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

    final unblocked = _state.cards.where((c) => !c.isBlocked && !c.isMatched).toList();
    final target = _state.level.targetSum;

    for (int i = 0; i < unblocked.length; i++) {
      for (int j = i + 1; j < unblocked.length; j++) {
        if (unblocked[i].value + unblocked[j].value == target) {
          final hintIds = [unblocked[i].id, unblocked[j].id];
          final updated = _state.cards.map((c) {
            return c.copyWith(isHinted: hintIds.contains(c.id));
          }).toList();

          _state = _state.copyWith(
            cards: updated,
            hintsRemaining: _state.hintsRemaining - 1,
          );
          notifyListeners();
          return;
        }
      }
    }
  }

  void undo() {
    if (_state.undoStack.isEmpty || _state.isWon || _state.isGameOver) return;

    final previous = _state.undoStack.last;
    final newStack = List<List<CardNode>>.from(_state.undoStack)..removeLast();

    final recomputed = OverlapEngine.updateBlockedStates(previous);

    _state = _state.copyWith(
      cards: recomputed,
      selectedCardIds: const [],
      undoStack: newStack,
      movesCount: (_state.movesCount - 1).clamp(0, 9999),
    );
    notifyListeners();
  }
}
