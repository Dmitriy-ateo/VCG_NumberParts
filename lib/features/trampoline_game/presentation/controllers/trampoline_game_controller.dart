import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:number_parts/core/audio/sound_manager.dart';
import 'package:number_parts/core/storage/progress_repository.dart';
import 'package:number_parts/features/trampoline_game/domain/logic/trampoline_task_generator.dart';
import 'package:number_parts/features/trampoline_game/domain/models/fox_animation_state.dart';
import 'package:number_parts/features/trampoline_game/domain/models/trampoline_data.dart';
import 'package:number_parts/features/trampoline_game/domain/models/trampoline_difficulty.dart';

class TrampolineGameController extends ChangeNotifier {
  final TrampolineDifficulty difficulty;
  final ProgressRepository progressRepository;

  late TrampolineRoundTask _currentRound;
  int _score = 0;
  int _bestScore = 0;
  bool _isNewBest = false;
  bool _isGameOver = false;

  FoxAnimationState _foxState = FoxAnimationState.falling;
  double _foxY = 0.0; // 0.0 (top sky) -> 1.0 (trampoline bed)
  double _foxX = 0.0; // -0.65 (left), 0.0 (center), 0.65 (right)

  int? _selectedTrampolineIndex;
  int? _squashingTrampolineIndex;
  Timer? _activeTimer;

  TrampolineGameController({
    required this.difficulty,
    required this.progressRepository,
  }) {
    _initGame();
  }

  TrampolineRoundTask get currentRound => _currentRound;
  int get score => _score;
  int get bestScore => _bestScore;
  bool get isNewBest => _isNewBest;
  bool get isGameOver => _isGameOver;
  FoxAnimationState get foxState => _foxState;
  double get foxY => _foxY;
  double get foxX => _foxX;
  int? get selectedTrampolineIndex => _selectedTrampolineIndex;
  int? get squashingTrampolineIndex => _squashingTrampolineIndex;

  double get _currentFallSpeed {
    double baseSpeed;
    switch (difficulty) {
      case TrampolineDifficulty.simple:
        baseSpeed = 0.00085;
        break;
      case TrampolineDifficulty.advanced:
        baseSpeed = 0.00095;
        break;
      case TrampolineDifficulty.hard:
        baseSpeed = 0.00110;
        break;
    }
    return baseSpeed + (_score * 0.00003).clamp(0.0, 0.0006);
  }

  Future<void> _initGame() async {
    _activeTimer?.cancel();
    _bestScore = await progressRepository.getTrampolineHighScore(difficulty.name);
    _score = 0;
    _isNewBest = false;
    _isGameOver = false;
    _foxState = FoxAnimationState.falling;
    _foxY = 0.0;
    _foxX = 0.0;
    _selectedTrampolineIndex = null;
    _squashingTrampolineIndex = null;

    _currentRound = TrampolineTaskGenerator.generateRound(difficulty: difficulty);
    _startFallLoop();
    notifyListeners();
  }

  void _startFallLoop() {
    _activeTimer?.cancel();

    _activeTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (_isGameOver) {
        timer.cancel();
        return;
      }

      if (_foxState == FoxAnimationState.falling && _selectedTrampolineIndex == null) {
        _foxY += _currentFallSpeed;
        if (_foxY >= 1.0) {
          // Fox reached ground without picking!
          _triggerGameOver();
        } else {
          notifyListeners();
        }
      }
    });
  }

  /// On trampoline select: Fox changes direction toward that trampoline
  /// and starts flying 2 times faster (no teleporting).
  void selectTrampoline(int index) {
    if (_isGameOver || _foxState != FoxAnimationState.falling || _selectedTrampolineIndex != null) {
      return;
    }

    _selectedTrampolineIndex = index;
    _activeTimer?.cancel();

    final targetX = index == 0 ? -0.65 : (index == 2 ? 0.65 : 0.0);
    const targetY = 0.95;
    final startX = _foxX;
    final startY = _foxY;
    final totalDistY = (targetY - startY).clamp(0.01, 1.0);

    // 2x faster than normal fall speed toward the chosen trampoline
    final diveSpeed = _currentFallSpeed * 2.0;

    _activeTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) async {
      if (_isGameOver) {
        timer.cancel();
        return;
      }

      _foxY += diveSpeed;
      final progress = ((_foxY - startY) / totalDistY).clamp(0.0, 1.0);
      _foxX = startX + (targetX - startX) * progress;

      if (_foxY >= targetY) {
        timer.cancel();
        _foxX = targetX;
        _foxY = targetY;

        final chosenTrampoline = _currentRound.trampolines[index];
        if (chosenTrampoline.isCorrect) {
          // ── CORRECT TRAMPOLINE LANDING! ────────────────────────────
          _foxState = FoxAnimationState.touchingTrampoline;
          _squashingTrampolineIndex = index;
          notifyListeners();

          SoundManager.instance.playMatchSound();
          await Future.delayed(const Duration(milliseconds: 220));

          if (_isGameOver) return;

          _score++;
          if (_score > _bestScore) {
            _bestScore = _score;
            _isNewBest = true;
            await progressRepository.saveTrampolineHighScore(difficulty.name, _score);
          }

          // ── FLY UP 2X FASTER THAN FALLING DOWN ──────────────────────
          _foxState = FoxAnimationState.flyingUp;
          _squashingTrampolineIndex = null;
          notifyListeners();

          final launchStartX = _foxX;
          final flyUpSpeed = _currentFallSpeed * 2.0;

          _activeTimer = Timer.periodic(const Duration(milliseconds: 16), (flyTimer) {
            if (_isGameOver) {
              flyTimer.cancel();
              return;
            }

            _foxY -= flyUpSpeed;
            // Smoothly curve X back to center (0.0) as it ascends to the top
            final upProgress = (1.0 - (_foxY / 0.95)).clamp(0.0, 1.0);
            _foxX = launchStartX * (1.0 - upProgress);

            if (_foxY <= 0.0) {
              flyTimer.cancel();
              _foxY = 0.0;
              _foxX = 0.0;
              _foxState = FoxAnimationState.falling;
              _selectedTrampolineIndex = null;
              _currentRound = TrampolineTaskGenerator.generateRound(difficulty: difficulty);
              _startFallLoop();
            }
            notifyListeners();
          });
        } else {
          // ── WRONG TRAMPOLINE! ─────────────────────────────────────
          _triggerGameOver();
        }
      } else {
        notifyListeners();
      }
    });
  }

  void _triggerGameOver() {
    _activeTimer?.cancel();
    _isGameOver = true;
    _foxState = FoxAnimationState.fallen;
    _foxY = 1.0;
    _squashingTrampolineIndex = null;
    SoundManager.instance.playWrongPickSound();
    SoundManager.instance.playLoseSound();
    notifyListeners();
  }

  void restart() {
    _initGame();
  }

  @override
  void dispose() {
    _activeTimer?.cancel();
    super.dispose();
  }
}
