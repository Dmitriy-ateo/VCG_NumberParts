import 'dart:math';
import 'package:flutter/material.dart';
import 'package:number_parts/app/theme/app_text_styles.dart';
import 'package:number_parts/core/l10n/app_localizations.dart';
import 'package:number_parts/core/storage/progress_repository.dart';
import 'package:number_parts/core/widgets/bouncy_button.dart';
import 'package:number_parts/features/labyrinth_game/domain/models/labyrinth_level.dart';
import 'package:number_parts/features/labyrinth_game/presentation/controllers/labyrinth_controller.dart';
import 'package:number_parts/features/labyrinth_game/presentation/widgets/chamber_stepper_bar.dart';
import 'package:number_parts/features/labyrinth_game/presentation/widgets/labyrinth_game_over_dialog.dart';
import 'package:number_parts/features/labyrinth_game/presentation/widgets/torch_glow_widget.dart';
import 'package:number_parts/features/labyrinth_game/presentation/widgets/treasure_reward_dialog.dart';
import 'package:number_parts/features/labyrinth_game/presentation/widgets/wooden_door_widget.dart';

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

  late AnimationController _povAnimController;
  Alignment _focalAlignment = Alignment.center;

  @override
  void initState() {
    super.initState();
    _controller = LabyrinthController(
      level: widget.level,
      progressRepository: _progressRepository,
    )..addListener(_onControllerUpdate);

    _povAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
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
      // Calculate focal point for POV zoom toward the chosen door
      final doorIdx =
          _controller.currentChamber.doorOptions.indexOf(doorValue);
      final alignX = doorIdx == 0 ? -0.65 : (doorIdx == 2 ? 0.65 : 0.0);

      setState(() {
        _focalAlignment = Alignment(alignX, 0.20);
      });

      _povAnimController.forward(from: 0.0);
    }

    _controller.selectDoor(doorValue);
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
          _povAnimController.reset();
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
          _povAnimController.reset();
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
    _povAnimController.dispose();
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
                      _povAnimController.reset();
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

            // ── FIRST-PERSON (POV) CHAMBER & DOORS VIEW ───────────────
            Expanded(
              child: AnimatedBuilder(
                animation: _povAnimController,
                builder: (context, child) {
                  final t = _povAnimController.value;
                  double scale = 1.0;
                  double bobY = 0.0;
                  double portalGlowOpacity = 0.0;
                  Alignment currentAlign = _focalAlignment;

                  if (t > 0.0 && t <= 0.52) {
                    // PHASE 1: POV Forward Zoom INTO the Selected Open Door
                    final progress = t / 0.52;
                    final curvedProgress =
                        Curves.easeInOutCubic.transform(progress);
                    scale = 1.0 + (curvedProgress * 2.6); // 1.0 -> 3.6x zoom
                    bobY = sin(progress * pi * 3) * 10; // Natural footstep bobbing

                    if (progress > 0.65) {
                      portalGlowOpacity =
                          ((progress - 0.65) / 0.35).clamp(0.0, 1.0);
                    }
                  } else if (t > 0.52) {
                    // PHASE 2: POV Emerge into the New Chamber & Settle to New Doors
                    final progress = (t - 0.52) / 0.48;
                    final curvedProgress =
                        Curves.easeOutCubic.transform(progress);
                    scale = 1.45 - (curvedProgress * 0.45); // 1.45 -> 1.0x settle
                    currentAlign = Alignment.center;
                    bobY = sin((1.0 - progress) * pi * 2) * 5;

                    if (progress < 0.45) {
                      portalGlowOpacity =
                          (1.0 - (progress / 0.45)).clamp(0.0, 1.0);
                    }
                  }

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Camera Transform
                      Transform(
                        alignment: currentAlign,
                        transform: Matrix4.identity()
                          ..translate(0.0, bobY)
                          ..scale(scale),
                        child: child,
                      ),

                      // Golden Portal Walkthrough Flash / Warm Light Wash
                      if (portalGlowOpacity > 0.0)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              color: const Color(0xFFFFE082)
                                  .withOpacity(portalGlowOpacity * 0.92),
                              child: Center(
                                child: Text(
                                  '✨',
                                  style: TextStyle(
                                    fontSize: 48,
                                    color: Colors.white
                                        .withOpacity(portalGlowOpacity),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
                child: Column(
                  children: [
                    const Spacer(flex: 1),

                    // ── HERO EQUATION PLAQUE ─────────────────────────
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFEECC), Color(0xFFFFD899)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xFFD49A55),
                            width: 3.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8A5A2B).withOpacity(0.2),
                              offset: const Offset(0, 6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF382312),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF25160A),
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFFFFF4DF),
                                    offset: Offset(0, 1),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: Text(
                                '${chamber.equation} = ?',
                                style: AppTextStyles.numberTile.copyWith(
                                  fontSize: 34,
                                  letterSpacing: 2.0,
                                  color: const Color(0xFFFFD43B),
                                  shadows: [
                                    const Shadow(
                                      color: Color(0xFF9A5B00),
                                      offset: Offset(0, 3),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // ── CHAMBER DOORS & TORCHES ──────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // Left Torch
                          const Positioned(
                            left: 0,
                            top: 10,
                            child: TorchGlowWidget(),
                          ),

                          // Right Torch
                          const Positioned(
                            right: 0,
                            top: 10,
                            child: TorchGlowWidget(),
                          ),

                          // Doors Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: chamber.doorOptions.map((doorVal) {
                              final isCorrect =
                                  _controller.selectedCorrectDoor == doorVal;
                              final isWrong =
                                  _controller.selectedWrongDoor == doorVal;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: WoodenDoorWidget(
                                  doorValue: doorVal,
                                  isCorrect: isCorrect,
                                  isWrong: isWrong,
                                  onTap: () => _onDoorTapped(doorVal),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 2),
                  ],
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
                            ? '✨ Stepping through the doorway... ✨'
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
