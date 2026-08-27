import 'package:flutter/foundation.dart';
import 'package:number_parts/core/audio/sound_manager.dart';
import 'package:number_parts/core/storage/progress_repository.dart';
import 'package:number_parts/features/labyrinth_game/domain/logic/labyrinth_task_generator.dart';
import 'package:number_parts/features/labyrinth_game/domain/models/labyrinth_chamber.dart';
import 'package:number_parts/features/labyrinth_game/domain/models/labyrinth_level.dart';

class LabyrinthController extends ChangeNotifier {
  final LabyrinthLevel level;
  final ProgressRepository progressRepository;

  late List<LabyrinthChamber> _chambers;
  int _currentChamberIndex = 0;
  int _lives = 3;
  int _mistakes = 0;

  int? _selectedCorrectDoor;
  int? _selectedWrongDoor;
  bool _isTransitioning = false;
  bool _isCompleted = false;
  bool _isGameOver = false;

  LabyrinthController({
    required this.level,
    required this.progressRepository,
  }) {
    _initLevel();
  }

  List<LabyrinthChamber> get chambers => _chambers;
  int get currentChamberIndex => _currentChamberIndex;
  int get totalChambers => _chambers.length;
  LabyrinthChamber get currentChamber => _chambers[_currentChamberIndex];
  LabyrinthChamber? get nextChamber =>
      (_currentChamberIndex + 1 < _chambers.length)
          ? _chambers[_currentChamberIndex + 1]
          : null;

  int get lives => _lives;
  int get mistakes => _mistakes;
  int? get selectedCorrectDoor => _selectedCorrectDoor;
  int? get selectedWrongDoor => _selectedWrongDoor;
  bool get isTransitioning => _isTransitioning;
  bool get isCompleted => _isCompleted;
  bool get isGameOver => _isGameOver;

  int get starsEarned {
    if (_mistakes == 0) return 3;
    if (_mistakes == 1) return 2;
    return 1;
  }

  void _initLevel() {
    _chambers = List.generate(
      level.chambersCount,
      (idx) => LabyrinthTaskGenerator.generateChamber(
        difficulty: level.difficulty,
        chamberIndex: idx,
      ),
    );
    _currentChamberIndex = 0;
    _lives = 3;
    _mistakes = 0;
    _selectedCorrectDoor = null;
    _selectedWrongDoor = null;
    _isTransitioning = false;
    _isCompleted = false;
    _isGameOver = false;
  }

  void restart() {
    _initLevel();
    notifyListeners();
  }

  Future<void> onCorrectDoorPicked(int doorValue) async {
    if (_isTransitioning || _isCompleted || _isGameOver) return;

    _selectedCorrectDoor = doorValue;
    _selectedWrongDoor = null;
    _isTransitioning = true;
    notifyListeners();

    // Trigger audio
    SoundManager.instance.playDoorOpenSound();
  }

  Future<void> completeTransition() async {
    if (_currentChamberIndex + 1 >= totalChambers) {
      // Level complete!
      _isCompleted = true;
      _isTransitioning = false;
      SoundManager.instance.playSuccessSound();

      final diffKey = level.difficulty.name;
      await progressRepository.saveLabyrinthStarsForLevel(
        diffKey,
        level.levelNumber,
        starsEarned,
      );
      await progressRepository.unlockLabyrinthLevel(
        diffKey,
        level.levelNumber + 1,
      );
      notifyListeners();
    } else {
      // Advance to next chamber
      _currentChamberIndex++;
      _selectedCorrectDoor = null;
      _isTransitioning = false;
      notifyListeners();
    }
  }

  Future<void> onWrongDoorPicked(int doorValue) async {
    if (_isTransitioning || _isCompleted || _isGameOver) return;

    _selectedWrongDoor = doorValue;
    _mistakes++;
    _lives--;
    SoundManager.instance.playDoorWrongSound();
    notifyListeners();

    if (_lives <= 0) {
      _isGameOver = true;
      SoundManager.instance.playLoseSound();
      notifyListeners();
    } else {
      await Future.delayed(const Duration(milliseconds: 600));
      _selectedWrongDoor = null;
      notifyListeners();
    }
  }

  Future<void> selectDoor(int doorValue) async {
    if (doorValue == currentChamber.correctAnswer) {
      await onCorrectDoorPicked(doorValue);
    } else {
      await onWrongDoorPicked(doorValue);
    }
  }
}
