import 'package:flutter/foundation.dart';
import '../../../../core/audio/sound_manager.dart';
import '../../../../core/storage/progress_repository.dart';
import '../../domain/models/miner_game_state.dart';
import '../../domain/models/miner_level_data.dart';

class FoxMinerController extends ChangeNotifier {
  final ProgressRepository progressRepository;
  MinerGameState _state;

  FoxMinerController({
    required MinerLevelData level,
    required this.progressRepository,
  }) : _state = MinerGameState.initial(level);

  MinerGameState get state => _state;
  MinerLevelData get level => _state.level;
  int get remainingNumber => _state.remainingNumber;
  int get tensCollected => _state.tensCollected;
  int get singlesCollected => _state.singlesCollected;
  int get totalSwings => _state.totalSwings;
  int get missedSwings => _state.missedSwings;
  bool get isCompleted => _state.isCompleted;
  int get starsEarned => _state.starsEarned;
  LastActionType get lastAction => _state.lastAction;

  bool get isKidFull => _state.isKidFull;
  bool get canHandoverTen => _state.canHandoverTen;
  bool get canMineSingles => _state.canMineSingles;
  bool get canMineTens => _state.canMineTens;

  /// Mom Fox mines a Ten (-10 from crystal, +10 to Mom's cart)
  void mineTens() {
    if (_state.isCompleted) return;

    // If Kid has 10 singles, hand them over to Mom's cart first
    if (_state.canHandoverTen) {
      handoverTen();
      return;
    }

    if (_state.remainingNumber >= 10) {
      final newRemaining = _state.remainingNumber - 10;
      final newTens = _state.tensCollected + 10;
      final newSwings = _state.totalSwings + 1;
      final isNowComplete = (newRemaining == 0 && _state.singlesCollected < 10);

      _state = _state.copyWith(
        remainingNumber: newRemaining,
        tensCollected: newTens,
        totalSwings: newSwings,
        isCompleted: isNowComplete,
        lastAction: LastActionType.minedTens,
      );

      SoundManager.instance.playMiningKirkAdultSound();
      if (isNowComplete) {
        _handleLevelCompletion();
      }
    } else {
      // Missed swing: trying to mine 10 when less than 10 remains
      _state = _state.copyWith(
        missedSwings: _state.missedSwings + 1,
        totalSwings: _state.totalSwings + 1,
        lastAction: LastActionType.missedTens,
      );
      SoundManager.instance.playMiningKirkFailsSound();
    }
    notifyListeners();
  }

  /// Kid Fox mines a Single (-1 from crystal, +1 to Kid's cart)
  void mineSingles() {
    if (_state.isCompleted) return;

    // Little one gets 10: he can't get more, he needs to hand 10 to mom cart!
    if (_state.singlesCollected >= 10) {
      return;
    }

    if (_state.remainingNumber >= 1) {
      final newRemaining = _state.remainingNumber - 1;
      final newSingles = _state.singlesCollected + 1;
      final newSwings = _state.totalSwings + 1;
      // If remaining is 0 but kid just reached 10, kid must hand 10 to mom before level completes!
      final isNowComplete = (newRemaining == 0 && newSingles < 10);

      _state = _state.copyWith(
        remainingNumber: newRemaining,
        singlesCollected: newSingles,
        totalSwings: newSwings,
        isCompleted: isNowComplete,
        lastAction: LastActionType.minedSingles,
      );

      SoundManager.instance.playMiningKirkChildSound();
      if (isNowComplete) {
        _handleLevelCompletion();
      }
    } else {
      // Missed swing: trying to mine 1 when 0 remains
      _state = _state.copyWith(
        missedSwings: _state.missedSwings + 1,
        totalSwings: _state.totalSwings + 1,
        lastAction: LastActionType.missedSingles,
      );
      SoundManager.instance.playMiningKirkFailsSound();
    }
    notifyListeners();
  }

  /// Kid Fox hands over 10 singles to Mom Fox's cart (+10 to Mom, -10 from Kid)
  void handoverTen() {
    if (_state.isCompleted) return;
    if (_state.singlesCollected < 10) return;

    final newTens = _state.tensCollected + 10;
    final newSingles = _state.singlesCollected - 10;
    final isNowComplete = (_state.remainingNumber == 0 && newSingles < 10);

    _state = _state.copyWith(
      tensCollected: newTens,
      singlesCollected: newSingles,
      isCompleted: isNowComplete,
      lastAction: LastActionType.handedOverTen,
    );

    SoundManager.instance.playMatchSound();
    if (isNowComplete) {
      _handleLevelCompletion();
    }
    notifyListeners();
  }

  Future<void> _handleLevelCompletion() async {
    Future.delayed(const Duration(milliseconds: 320), () {
      SoundManager.instance.playSuccessSound();
    });
    final stars = _state.starsEarned;
    await progressRepository.saveFoxMinerStarsForLevel(level.levelNumber, stars);
    await progressRepository.unlockFoxMinerLevel(level.levelNumber + 1);
  }

  void resetLevel() {
    _state = MinerGameState.initial(_state.level);
    notifyListeners();
  }

  void loadLevel(MinerLevelData newLevel) {
    _state = MinerGameState.initial(newLevel);
    notifyListeners();
  }
}
