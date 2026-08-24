import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../domain/models/level_data.dart';
import 'controllers/game_controller.dart';
import 'widgets/board_view.dart';
import 'widgets/game_over_dialog.dart';
import 'widgets/lives_display.dart';
import 'widgets/target_badge.dart';
import 'widgets/victory_dialog.dart';

class NumberBondsGameScreen extends StatefulWidget {
  final LevelData level;

  const NumberBondsGameScreen({
    super.key,
    required this.level,
  });

  @override
  State<NumberBondsGameScreen> createState() => _NumberBondsGameScreenState();
}

class _NumberBondsGameScreenState extends State<NumberBondsGameScreen> {
  late final GameController _controller;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _controller = GameController(widget.level);
    _controller.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onGameStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onGameStateChanged() {
    if (!mounted) return;

    if (_controller.state.isWon && !_dialogShown) {
      _dialogShown = true;
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        VictoryDialog.show(
          context,
          stars: _controller.state.calculatedStars,
          movesCount: _controller.state.movesCount,
          onNextLevel: () {
            _dialogShown = false;
            _controller.nextLevel();
          },
          onReplay: () {
            _dialogShown = false;
            _controller.restart();
          },
          onHome: () {
            Navigator.of(context).pop();
          },
        );
      });
    } else if (_controller.state.isGameOver && !_dialogShown) {
      _dialogShown = true;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        GameOverDialog.show(
          context,
          onRetry: () {
            _dialogShown = false;
            _controller.restart();
          },
          onHome: () {
            Navigator.of(context).pop();
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context).strings;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final state = _controller.state;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Top Header Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    children: [
                      // Back Button
                      BouncyButton(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        backgroundColor: AppColors.surfaceWarm,
                        shadowColor: AppColors.woodBorder,
                        borderRadius: BorderRadius.circular(16),
                        bevelHeight: 3.5,
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Target Badge
                      TargetBadge(targetSum: state.level.targetSum),
                      const Spacer(),

                      // Lives Display (3 Hearts)
                      LivesDisplay(lives: state.lives, maxLives: state.maxLives),
                      const SizedBox(width: 10),

                      // Restart Button
                      BouncyButton(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        backgroundColor: AppColors.surfaceWarm,
                        shadowColor: AppColors.woodBorder,
                        borderRadius: BorderRadius.circular(16),
                        bevelHeight: 3.5,
                        onPressed: () => _controller.restart(),
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: AppColors.textPrimary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                // Card Selection Helper / Subtitle Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.woodBorder.withAlpha(100)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${l10n.levelNumberLabel} ${state.level.levelNumber}',
                          style: AppTextStyles.badge.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: 12),
                        Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.textMuted)),
                        const SizedBox(width: 12),
                        Text(
                          '${l10n.remainingCards}: ${state.remainingCardsCount}',
                          style: AppTextStyles.badge.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Game Playing Field
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: BoardView(
                      cards: state.cards,
                      showDots: state.level.showDots,
                      onCardTapped: (cardId) => _controller.onCardTapped(cardId),
                    ),
                  ),
                ),

                // Bottom Control Actions (Hint, Undo)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  child: Row(
                    children: [
                      // Hint Button
                      Expanded(
                        child: BouncyButton(
                          height: 52,
                          backgroundColor: AppColors.pastelYellow,
                          shadowColor: AppColors.pastelYellowDark,
                          borderRadius: BorderRadius.circular(18),
                          onPressed: () {
                            if (state.hintsRemaining > 0) {
                              _controller.useHint();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.noMoreHints),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('💡', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Text(
                                  '${l10n.hintButton} (${state.hintsRemaining})',
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Undo Button
                      Expanded(
                        child: BouncyButton(
                          height: 52,
                          backgroundColor: AppColors.surfaceWarm,
                          shadowColor: AppColors.woodBorder,
                          borderRadius: BorderRadius.circular(18),
                          onPressed: state.undoStack.isNotEmpty ? () => _controller.undo() : null,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.undo_rounded,
                                  color: state.undoStack.isNotEmpty
                                      ? AppColors.textPrimary
                                      : AppColors.textMuted,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.undoButton,
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: state.undoStack.isNotEmpty
                                        ? AppColors.textPrimary
                                        : AppColors.textMuted,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
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
      },
    );
  }
}
