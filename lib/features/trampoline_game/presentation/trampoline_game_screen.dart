import 'package:flutter/material.dart';
import 'package:number_parts/app/theme/app_text_styles.dart';
import 'package:number_parts/core/l10n/app_localizations.dart';
import 'package:number_parts/core/storage/progress_repository.dart';
import 'package:number_parts/core/widgets/bouncy_button.dart';
import 'package:number_parts/features/trampoline_game/domain/models/fox_animation_state.dart';
import 'package:number_parts/features/trampoline_game/domain/models/trampoline_difficulty.dart';
import 'package:number_parts/features/trampoline_game/presentation/controllers/trampoline_game_controller.dart';
import 'package:number_parts/features/trampoline_game/presentation/widgets/animated_fox_character.dart';
import 'package:number_parts/features/trampoline_game/presentation/widgets/sky_parallax_background.dart';
import 'package:number_parts/features/trampoline_game/presentation/widgets/spring_trampoline_widget.dart';
import 'package:number_parts/features/trampoline_game/presentation/widgets/trampoline_game_over_dialog.dart';

class TrampolineGameScreen extends StatefulWidget {
  final TrampolineDifficulty difficulty;

  const TrampolineGameScreen({
    super.key,
    required this.difficulty,
  });

  @override
  State<TrampolineGameScreen> createState() => _TrampolineGameScreenState();
}

class _TrampolineGameScreenState extends State<TrampolineGameScreen> {
  late TrampolineGameController _controller;
  final ProgressRepository _progressRepository = ProgressRepository();

  @override
  void initState() {
    super.initState();
    _controller = TrampolineGameController(
      difficulty: widget.difficulty,
      progressRepository: _progressRepository,
    )..addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    setState(() {});

    if (_controller.isGameOver) {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => TrampolineGameOverDialog(
        score: _controller.score,
        bestScore: _controller.bestScore,
        isNewBest: _controller.isNewBest,
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
    final round = _controller.currentRound;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      body: SafeArea(
        child: SkyParallaxBackground(
          child: Column(
            children: [
              // ── TOP BAR / SCORES ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
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

                    // Current Score Badge
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
                              l10n.strings.scoreLabel,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 11,
                                color: const Color(0xFFA67B48),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_controller.score}',
                              style: AppTextStyles.numberTile.copyWith(
                                fontSize: 18,
                                color: const Color(0xFF8A5A2B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Best Score Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 14),
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
                            l10n.strings.bestScoreLabel,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 11,
                              color: const Color(0xFFA67B48),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '⭐ ${_controller.bestScore}',
                            style: AppTextStyles.numberTile.copyWith(
                              fontSize: 18,
                              color: const Color(0xFFE8590C),
                            ),
                          ),
                        ],
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

              // ── SKY & TRAMPOLINE INTERACTIVE PLAY AREA ─────────
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final areaWidth = constraints.maxWidth;
                    final areaHeight = constraints.maxHeight;

                    // Compute Fox pixel coordinates right to the trampoline surface
                    final foxPixelX =
                        (areaWidth / 2) + (_controller.foxX * (areaWidth * 0.46));
                    const topSkyY = 15.0;
                    // Trampoline mat surface is ~50px from the bottom
                    final trampolineBedY = areaHeight - 155.0;
                    final foxPixelY =
                        topSkyY + (_controller.foxY * (trampolineBedY - topSkyY));

                    // Compute banking tilt during directional flight
                    double foxTilt = 0.0;
                    if (_controller.selectedTrampolineIndex != null) {
                      final targetX = _controller.selectedTrampolineIndex == 0
                          ? -0.65
                          : (_controller.selectedTrampolineIndex == 2 ? 0.65 : 0.0);
                      foxTilt = (targetX - _controller.foxX) * 0.28;
                    } else if (_controller.foxState == FoxAnimationState.flyingUp) {
                      foxTilt = -_controller.foxX * 0.15;
                    }

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // ── 1. TRAMPOLINES ROW (Base Z-Index layer) ───────
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: round.trampolines.map((trampoline) {
                              final isSelected =
                                  _controller.selectedTrampolineIndex ==
                                      trampoline.index;
                              final visualState =
                                  _controller.getTrampolineVisualState(
                                      trampoline.index);

                              return SpringTrampolineWidget(
                                trampoline: trampoline,
                                visualState: visualState,
                                isSelected: isSelected,
                                onTap: () => _controller
                                    .selectTrampoline(trampoline.index),
                              );
                            }).toList(),
                          ),
                        ),

                        // ── 2. ANIMATED FOX (Top Z-Index: renders in front of trampolines) ──
                        Positioned(
                          left: foxPixelX - 60,
                          top: foxPixelY,
                          child: AnimatedFoxCharacter(
                            state: _controller.foxState,
                            targetNumber: round.targetNumber,
                            tilt: foxTilt,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // ── HINT FOOTER ──────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 12, left: 16, right: 16, top: 4),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6E5),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: const Color(0xFFE5CE9F), width: 1.5),
                  ),
                  child: Text(
                    l10n.strings.tapTrampolineHint,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8A5A2B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
