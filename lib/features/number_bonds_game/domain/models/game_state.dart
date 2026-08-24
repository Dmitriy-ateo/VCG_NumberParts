import 'package:flutter/foundation.dart';
import 'card_node.dart';
import 'level_data.dart';

@immutable
class GameState {
  final LevelData level;
  final List<CardNode> cards;
  final int lives;
  final int maxLives;
  final List<String> selectedCardIds;
  final bool isWon;
  final bool isGameOver;
  final int hintsRemaining;
  final List<List<CardNode>> undoStack;
  final int movesCount;
  final int mistakesCount;

  const GameState({
    required this.level,
    required this.cards,
    this.lives = 3,
    this.maxLives = 3,
    this.selectedCardIds = const [],
    this.isWon = false,
    this.isGameOver = false,
    this.hintsRemaining = 3,
    this.undoStack = const [],
    this.movesCount = 0,
    this.mistakesCount = 0,
  });

  int get remainingCardsCount => cards.where((c) => !c.isMatched).length;

  int get calculatedStars {
    if (!isWon) return 0;
    if (mistakesCount == 0) return 3;
    if (mistakesCount == 1) return 2;
    return 1;
  }

  GameState copyWith({
    LevelData? level,
    List<CardNode>? cards,
    int? lives,
    int? maxLives,
    List<String>? selectedCardIds,
    bool? isWon,
    bool? isGameOver,
    int? hintsRemaining,
    List<List<CardNode>>? undoStack,
    int? movesCount,
    int? mistakesCount,
  }) {
    return GameState(
      level: level ?? this.level,
      cards: cards ?? this.cards,
      lives: lives ?? this.lives,
      maxLives: maxLives ?? this.maxLives,
      selectedCardIds: selectedCardIds ?? this.selectedCardIds,
      isWon: isWon ?? this.isWon,
      isGameOver: isGameOver ?? this.isGameOver,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
      undoStack: undoStack ?? this.undoStack,
      movesCount: movesCount ?? this.movesCount,
      mistakesCount: mistakesCount ?? this.mistakesCount,
    );
  }
}
