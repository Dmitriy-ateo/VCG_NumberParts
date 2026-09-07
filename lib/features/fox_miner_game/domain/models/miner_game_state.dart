import 'miner_level_data.dart';

enum LastActionType {
  none,
  minedTens,
  minedSingles,
  missedTens,
  missedSingles,
  handedOverTen,
}

class MinerGameState {
  final MinerLevelData level;
  final int remainingNumber;
  final int tensCollected;
  final int singlesCollected;
  final int totalSwings;
  final int missedSwings;
  final bool isCompleted;
  final LastActionType lastAction;

  const MinerGameState({
    required this.level,
    required this.remainingNumber,
    required this.tensCollected,
    required this.singlesCollected,
    required this.totalSwings,
    required this.missedSwings,
    required this.isCompleted,
    this.lastAction = LastActionType.none,
  });

  factory MinerGameState.initial(MinerLevelData level) {
    return MinerGameState(
      level: level,
      remainingNumber: level.targetNumber,
      tensCollected: 0,
      singlesCollected: 0,
      totalSwings: 0,
      missedSwings: 0,
      isCompleted: false,
      lastAction: LastActionType.none,
    );
  }

  /// Calculates stars based on swings efficiency:
  /// - 3 stars: only for optimal swings (totalSwings <= level.optimalSwings && missedSwings == 0, e.g. 10/10)
  /// - 2 stars: near-optimal (extraSwings <= 2 && missedSwings <= 2)
  /// - 1 star: completed with extra swings (e.g. 46 hits when optimal was 10)
  int get starsEarned {
    if (!isCompleted) return 0;
    final extraSwings = totalSwings - level.optimalSwings;
    if (extraSwings <= 0 && missedSwings == 0) return 3;
    if (extraSwings <= 2 && missedSwings <= 2) return 2;
    return 1;
  }

  /// Damage percentage of the crystal (0.0 untouched -> 1.0 completely broken)
  double get crackProgress {
    if (level.targetNumber == 0) return 1.0;
    final mined = level.targetNumber - remainingNumber;
    return (mined / level.targetNumber).clamp(0.0, 1.0);
  }

  /// True if Kid Fox has collected 10 singles and his cart is full
  bool get isKidFull => singlesCollected >= 10;

  /// True if Kid Fox can hand over 10 singles to Mom Fox's cart
  bool get canHandoverTen => singlesCollected >= 10 && !isCompleted;

  /// True if Kid Fox is allowed to mine a single crystal
  bool get canMineSingles => !isCompleted && singlesCollected < 10 && remainingNumber >= 1;

  /// True if Mom Fox is allowed to mine a ten crystal
  bool get canMineTens => !isCompleted && !isKidFull && remainingNumber >= 10;

  MinerGameState copyWith({
    int? remainingNumber,
    int? tensCollected,
    int? singlesCollected,
    int? totalSwings,
    int? missedSwings,
    bool? isCompleted,
    LastActionType? lastAction,
  }) {
    return MinerGameState(
      level: level,
      remainingNumber: remainingNumber ?? this.remainingNumber,
      tensCollected: tensCollected ?? this.tensCollected,
      singlesCollected: singlesCollected ?? this.singlesCollected,
      totalSwings: totalSwings ?? this.totalSwings,
      missedSwings: missedSwings ?? this.missedSwings,
      isCompleted: isCompleted ?? this.isCompleted,
      lastAction: lastAction ?? this.lastAction,
    );
  }
}
