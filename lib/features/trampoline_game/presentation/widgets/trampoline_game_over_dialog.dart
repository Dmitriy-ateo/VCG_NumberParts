import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/bouncy_button.dart';

class TrampolineGameOverDialog extends StatelessWidget {
  final int score;
  final int bestScore;
  final bool isNewBest;
  final VoidCallback onRetry;
  final VoidCallback onHome;

  const TrampolineGameOverDialog({
    super.key,
    required this.score,
    required this.bestScore,
    required this.isNewBest,
    required this.onRetry,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9EE),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFE5CE9F), width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8A5A2B).withOpacity(0.35),
              offset: const Offset(0, 10),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mascot Fallen Emoji
            const Text('🦊', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 8),

            // Title
            Text(
              isNewBest
                  ? l10n.strings.newHighScoreTitle
                  : l10n.strings.gameOverTitle,
              style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              l10n.strings.gameOverSubtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFFA67B48),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // ── SCORE DISPLAY BADGE ─────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0D4),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFDFC497), width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        l10n.strings.scoreLabel,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          color: const Color(0xFFA67B48),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$score',
                        style: AppTextStyles.numberTile.copyWith(
                          fontSize: 28,
                          color: const Color(0xFF8A5A2B),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 2,
                    height: 36,
                    color: const Color(0xFFDFC497),
                  ),
                  Column(
                    children: [
                      Text(
                        l10n.strings.bestScoreLabel,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          color: const Color(0xFFA67B48),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$bestScore',
                        style: AppTextStyles.numberTile.copyWith(
                          fontSize: 28,
                          color: const Color(0xFFE8590C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── ACTION BUTTONS ──────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: BouncyButton(
                    onPressed: onHome,
                    backgroundColor: const Color(0xFFFFF3DB),
                    shadowColor: const Color(0xFFE8C88A),
                    height: 52,
                    child: Text(
                      l10n.strings.homeButton,
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: const Color(0xFF8A5A2B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BouncyButton(
                    onPressed: onRetry,
                    backgroundColor: AppColors.pastelSage,
                    shadowColor: AppColors.pastelSageDark,
                    height: 52,
                    child: Text(
                      l10n.strings.tryAgainButton,
                      style: AppTextStyles.buttonLarge.copyWith(
                        color: const Color(0xFF2B5329),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
