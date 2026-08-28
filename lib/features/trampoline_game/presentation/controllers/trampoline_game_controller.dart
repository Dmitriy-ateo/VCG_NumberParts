import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/audio/sound_manager.dart';
import '../../../../core/storage/progress_repository.dart';
import '../../domain/logic/trampoline_task_generator.dart';
import '../../domain/models/fox_animation_state.dart';
import '../../domain/models/trampoline_data.dart';
import '../../domain/models/trampoline_difficulty.dart';

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
  Timer? _fallTimer;

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

  Future<void> _initGame() async {
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
    _fallTimer?.cancel();

    // Fall speed: generous time for reading and calculation
    // Simple: ~19s, Advanced: ~17s, Hard: ~15s
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

    final speed = baseSpeed + (_score * 0.00003).clamp(0.0, 0.0006);

    _fallTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (_isGameOver) {
        timer.cancel();
        return;
      }

      if (_foxState == FoxAnimationState.falling) {
        _foxY += speed;
        if (_foxY >= 1.0) {
          // Fox hit the ground without picking correctly!
          _triggerGameOver();
        } else {
          notifyListeners();
        }
      }
    });
  }

  Future<void> selectTrampoline(int index) async {
    if (_isGameOver || _foxState != FoxAnimationState.falling) return;

    _selectedTrampolineIndex = index;
    final targetX = index == 0 ? -0.65 : (index == 2 ? 0.65 : 0.0);
    final chosenTrampoline = _currentRound.trampolines[index];

    if (chosenTrampoline.isCorrect) {
      // ── CORRECT TRAMPOLINE! ───────────────────────────────────────
      // 1. Move Fox to Trampoline X
      _foxX = targetX;
      _foxY = 0.95;
      _foxState = FoxAnimationState.touchingTrampoline;
      _squashingTrampolineIndex = index;
      notifyListeners();

      // Sound & Spring deflection
      SoundManager.instance.playMatchSound();
      await Future.delayed(const Duration(milliseconds: 160));

      // 2. Launch Fox into the Sky!
      _score++;
      if (_score > _bestScore) {
        _bestScore = _score;
        _isNewBest = true;
        await progressRepository.saveTrampolineHighScore(difficulty.name, _score);
      }

      _foxState = FoxAnimationState.flyingUp;
      _squashingTrampolineIndex = null;
      notifyListeners();

      // Animate flight to top (350ms)
      const flightSteps = 15;
      for (int i = 0; i < flightSteps; i++) {
        _foxY = 0.95 - ((i + 1) / flightSteps) * 0.95;
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 20));
      }

      // 3. Generate New Round and start falling again
      _currentRound = TrampolineTaskGenerator.generateRound(difficulty: difficulty);
      _selectedTrampolineIndex = null;
      _foxX = 0.0;
      _foxY = 0.0;
      _foxState = FoxAnimationState.falling;
      notifyListeners();

      _startFallLoop();
    } else {
      // ── WRONG TRAMPOLINE! ─────────────────────────────────────────
      _foxX = targetX;
      _triggerGameOver();
    }
  }

  void _triggerGameOver() {
    _fallTimer?.cancel();
    _isGameOver = true;
    _foxState = FoxAnimationState.fallen;
    _foxY = 1.0;
    SoundManager.instance.playWrongPickSound();
    SoundManager.instance.playLoseSound();
    notifyListeners();
  }

  void restart() {
    _initGame();
  }

  @override
  void dispose() {
    _fallTimer?.cancel();
    super.dispose();
  }
}
