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

class _LabyrinthGameScreenState extends State<LabyrinthGameScreen> {
  late LabyrinthController _controller;
  final ProgressRepository _progressRepository = ProgressRepository();

  @override
  void initState() {
    super.initState();
    _controller = LabyrinthController(
      level: widget.level,
      progressRepository: _progressRepository,
    )..addListener(_onControllerUpdate);
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
            title: '${widget.level.title.split(' ').first} ${widget.level.levelNumber + 1}',
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LabyrinthGameScreen(level: nextLevel),
            ),
          );
        },
        onReplay: () {
          Navigator.of(ctx).pop();
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
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8EC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5CE9F), width: 2),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8EC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5CE9F), width: 2),
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
                    onPressed: _controller.restart,
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

            // ── HERO EQUATION PLAQUE ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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

            const Spacer(),

            // ── CHAMBER DOORS & TORCHES ────────────────────────────────
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
                      final isCorrect = _controller.selectedCorrectDoor == doorVal;
                      final isWrong = _controller.selectedWrongDoor == doorVal;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: WoodenDoorWidget(
                          doorValue: doorVal,
                          isCorrect: isCorrect,
                          isWrong: isWrong,
                          onTap: () => _controller.selectDoor(doorVal),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── MASCOT & INSTRUCTION BANNER ────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mascot Fox
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE8590C), width: 2.5),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/mascot_fox.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Hint Speech Bubble
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6E5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5CE9F), width: 2),
                      ),
                      child: Text(
                        l10n.strings.doorsChooseHint,
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
