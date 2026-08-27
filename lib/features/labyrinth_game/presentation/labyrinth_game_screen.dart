import 'dart:math';
import 'package:flutter/material.dart';
import 'package:number_parts/app/theme/app_text_styles.dart';
import 'package:number_parts/core/l10n/app_localizations.dart';
import 'package:number_parts/core/storage/progress_repository.dart';
import 'package:number_parts/core/widgets/bouncy_button.dart';
import 'package:number_parts/features/labyrinth_game/domain/models/labyrinth_chamber.dart';
import 'package:number_parts/features/labyrinth_game/domain/models/labyrinth_level.dart';
import 'package:number_parts/features/labyrinth_game/presentation/controllers/labyrinth_controller.dart';
import 'package:number_parts/features/labyrinth_game/presentation/widgets/chamber_content_view.dart';
import 'package:number_parts/features/labyrinth_game/presentation/widgets/chamber_stepper_bar.dart';
import 'package:number_parts/features/labyrinth_game/presentation/widgets/labyrinth_game_over_dialog.dart';
import 'package:number_parts/features/labyrinth_game/presentation/widgets/treasure_reward_dialog.dart';

class LabyrinthGameScreen extends StatefulWidget {
  final LabyrinthLevel level;

  const LabyrinthGameScreen({
    super.key,
    required this.level,
  });

  @override
  State<LabyrinthGameScreen> createState() => _LabyrinthGameScreenState();
}

class _LabyrinthGameScreenState extends State<LabyrinthGameScreen>
    with SingleTickerProviderStateMixin {
  late LabyrinthController _controller;
  final ProgressRepository _progressRepository = ProgressRepository();

  late AnimationController _walkAnimController;
  Alignment _focalAlignment = Alignment.center;
  LabyrinthChamber? _transitionOldChamber;
  LabyrinthChamber? _transitionNextChamber;

  @override
  void initState() {
    super.initState();
    _controller = LabyrinthController(
      level: widget.level,
      progressRepository: _progressRepository,
    )..addListener(_onControllerUpdate);

    _walkAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.completeTransition();
          _walkAnimController.reset();
        }
      });
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    setState(() {});

    if (_controller.isCompleted) {
      _showVictoryDialog();
    } else if (_controller.isGameOver) {
      _showGameOverDialog();
    }
  }

  void _onDoorTapped(int doorValue) {
    if (_controller.isTransitioning ||
        _controller.isCompleted ||
        _controller.isGameOver) {
      return;
    }

    if (doorValue == _controller.currentChamber.correctAnswer) {
      // 1. Calculate focal point for POV zoom toward the chosen door
      final current = _controller.currentChamber;
      final doorIdx = current.doorOptions.indexOf(doorValue);
      final alignX = doorIdx == 0 ? -0.65 : (doorIdx == 2 ? 0.65 : 0.0);

      setState(() {
        _focalAlignment = Alignment(alignX, 0.18);
        _transitionOldChamber = current;
        _transitionNextChamber = _controller.nextChamber;
      });

      _controller.onCorrectDoorPicked(doorValue);
      _walkAnimController.forward(from: 0.0);
    } else {
      _controller.onWrongDoorPicked(doorValue);
    }
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => TreasureRewardDialog(
        stars: _controller.starsEarned,
        onNextLevel: () {
          Navigator.of(ctx).pop();
          final nextLevel = LabyrinthLevel(
            levelNumber: widget.level.levelNumber + 1,
            difficulty: widget.level.difficulty,
            chambersCount: widget.level.chambersCount,
            title:
                '${widget.level.title.split(' ').first} ${widget.level.levelNumber + 1}',
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LabyrinthGameScreen(level: nextLevel),
            ),
          );
        },
        onReplay: () {
          Navigator.of(ctx).pop();
          _walkAnimController.reset();
          _controller.restart();
        },
        onHome: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => LabyrinthGameOverDialog(
        onRetry: () {
          Navigator.of(ctx).pop();
          _walkAnimController.reset();
          _controller.restart();
        },
        onHome: () {
          Navigator.of(ctx).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  void dispose() {
    _walkAnimController.dispose();
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chamber = _controller.currentChamber;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP HEADER ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Back Button
                  BouncyButton(
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: const Color(0xFFFFF3DB),
                    shadowColor: const Color(0xFFE8C88A),
                    padding: EdgeInsets.zero,
                    height: 48,
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20, color: Color(0xFF8A5A2B)),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Level Badge
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8EC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFE5CE9F), width: 2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${l10n.strings.levelNumberLabel} ${widget.level.levelNumber}',
                            style: AppTextStyles.numberTile.copyWith(
                              fontSize: 15,
                              color: const Color(0xFF8A5A2B),
                            ),
                          ),
                          Text(
                            '${l10n.strings.chamberLabel} ${_controller.currentChamberIndex + 1}/${_controller.totalChambers}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 11,
                              color: const Color(0xFFA67B48),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Lives Display
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8EC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFE5CE9F), width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            i < _controller.lives ? '❤️' : '🤍',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Restart Button
                  BouncyButton(
                    onPressed: () {
                      _walkAnimController.reset();
                      _controller.restart();
                    },
                    backgroundColor: const Color(0xFFFFF3DB),
                    shadowColor: const Color(0xFFE8C88A),
                    padding: EdgeInsets.zero,
                    height: 48,
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.refresh_rounded,
                          size: 24, color: Color(0xFF8A5A2B)),
                    ),
                  ),
                ],
              ),
            ),

            // ── PROGRESS STEPPER ───────────────────────────────────────
            ChamberStepperBar(
              currentIndex: _controller.currentChamberIndex,
              totalChambers: _controller.totalChambers,
            ),

            // ── FIRST-PERSON (POV) CHAMBER WALKTHROUGH ────────────────
            Expanded(
              child: ClipRect(
                child: AnimatedBuilder(
                  animation: _walkAnimController,
                  builder: (context, child) {
                    final t = _walkAnimController.value;

                    if (!_controller.isTransitioning ||
                        _transitionOldChamber == null) {
                      // Normal static chamber view
                      return Center(
                        child: ChamberContentView(
                          chamber: chamber,
                          selectedCorrectDoor: _controller.selectedCorrectDoor,
                          selectedWrongDoor: _controller.selectedWrongDoor,
                          onDoorTapped: _onDoorTapped,
                        ),
                      );
                    }

                    // ── DYNAMIC POV WALK TRANSITION ──────────────────
                    // Phase 1: Old chamber zooms into open door (0.0 -> 0.65)
                    // Phase 2: Next chamber emerges from small (0.28x) to actual size (1.0x) (0.45 -> 1.0)
                    final oldChamber = _transitionOldChamber!;
                    final nextChamber = _transitionNextChamber;

                    // Footstep bobbing
                    final bobY = sin(t * pi * 4) * 7.0;

                    // Old Chamber Scale: 1.0 -> 4.8x focused on door
                    final oldProgress = (t / 0.65).clamp(0.0, 1.0);
                    final oldScale = 1.0 + (Curves.easeInOutCubic.transform(oldProgress) * 3.8);
                    final oldOpacity = t <= 0.45
                        ? 1.0
                        : (1.0 - ((t - 0.45) / 0.20)).clamp(0.0, 1.0);

                    // Next Chamber Scale: 0.26x -> 1.0x (actual size)
                    final nextProgress = ((t - 0.45) / 0.55).clamp(0.0, 1.0);
                    final nextScale = 0.26 + (Curves.easeOutCubic.transform(nextProgress) * 0.74);
                    final nextOpacity = t <= 0.45
                        ? 0.0
                        : ((t - 0.45) / 0.20).clamp(0.0, 1.0);

                    // Hallway preview (rendered inside the open wooden door of the old chamber)
                    Widget buildHallwayPreview() {
                      if (nextChamber == null) {
                        return Container(
                          color: const Color(0xFFFFF3C4),
                          child: const Center(
                            child: Text('🏆', style: TextStyle(fontSize: 32)),
                          ),
                        );
                      }

                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF382312), Color(0xFF1E1308)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(
                          child: Transform.scale(
                            scale: 0.22,
                            child: ChamberContentView(chamber: nextChamber),
                          ),
                        ),
                      );
                    }

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // ── 1. OLD CHAMBER (Zooming in to chosen door) ───
                        if (oldOpacity > 0.0)
                          Transform(
                            alignment: _focalAlignment,
                            transform: Matrix4.identity()
                              ..translate(0.0, bobY)
                              ..scale(oldScale),
                            child: Opacity(
                              opacity: oldOpacity,
                              child: ChamberContentView(
                                chamber: oldChamber,
                                selectedCorrectDoor:
                                    _controller.selectedCorrectDoor,
                                hallwayPreview: buildHallwayPreview(),
                              ),
                            ),
                          ),

                        // ── 2. NEW CHAMBER (Zooming from small to actual size) ───
                        if (nextOpacity > 0.0 && nextChamber != null)
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..translate(0.0, bobY * 0.5)
                              ..scale(nextScale),
                            child: Opacity(
                              opacity: nextOpacity,
                              child: ChamberContentView(
                                chamber: nextChamber,
                              ),
                            ),
                          ),

                        // ── 3. TREASURE ROOM VICTORY PREVIEW (if last chamber) ───
                        if (nextOpacity > 0.0 && nextChamber == null)
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..scale(nextScale),
                            child: Opacity(
                              opacity: nextOpacity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('👑',
                                      style: TextStyle(fontSize: 72)),
                                  const SizedBox(height: 12),
                                  Text(
                                    '✨ Treasure Chamber Reached! ✨',
                                    style: AppTextStyles.titleMedium
                                        .copyWith(color: const Color(0xFF8A5A2B)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // ── MASCOT & INSTRUCTION BANNER ────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mascot Fox
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.elasticOut,
                    transform: Matrix4.translationValues(
                      0,
                      _controller.isTransitioning ? -8 : 0,
                      0,
                    ),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFE8590C), width: 2.5),
                        boxShadow: [
                          if (_controller.isTransitioning)
                            BoxShadow(
                              color: const Color(0xFFFFD43B).withOpacity(0.6),
                              blurRadius: 12,
                              spreadRadius: 3,
                            ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/images/mascot_fox.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Hint Speech Bubble
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6E5),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: const Color(0xFFE5CE9F), width: 2),
                      ),
                      child: Text(
                        _controller.isTransitioning
                            ? '✨ Walking into the next chamber... ✨'
                            : l10n.strings.doorsChooseHint,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8A5A2B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
