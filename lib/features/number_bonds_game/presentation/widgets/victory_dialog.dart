import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/bouncy_button.dart';

class VictoryDialog extends StatelessWidget {
  final int stars;
  final int movesCount;
  final VoidCallback onNextLevel;
  final VoidCallback onReplay;
  final VoidCallback onHome;

  const VictoryDialog({
    super.key,
    required this.stars,
    required this.movesCount,
    required this.onNextLevel,
    required this.onReplay,
    required this.onHome,
  });

  static Future<void> show(
    BuildContext context, {
    required int stars,
    required int movesCount,
    required VoidCallback onNextLevel,
    required VoidCallback onReplay,
    required VoidCallback onHome,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Victory',
      barrierColor: Colors.black.withAlpha(90),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return VictoryDialog(
          stars: stars,
          movesCount: movesCount,
          onNextLevel: onNextLevel,
          onReplay: onReplay,
          onHome: onHome,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim1.value),
          child: Opacity(opacity: anim1.value, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context).strings;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.woodBorder, width: 3.5),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowWarmStrong,
              offset: Offset(0, 14),
              blurRadius: 28,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Celebratory Stars Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final earned = index < stars;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    earned ? '⭐' : '☆',
                    style: TextStyle(
                      fontSize: index == 1 ? 48 : 36,
                      color: AppColors.pastelYellowDark,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),

            // Title & Subtitle
            Text(
              l10n.victoryTitle,
              style: AppTextStyles.titleMedium.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.victorySubtitle,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Next Level Primary Button
            SizedBox(
              width: double.infinity,
              child: BouncyButton(
                height: 60,
                backgroundColor: AppColors.pastelSage,
                shadowColor: AppColors.pastelSageDark,
                borderRadius: BorderRadius.circular(20),
                onPressed: () {
                  Navigator.of(context).pop();
                  onNextLevel();
                },
                child: Center(
                  child: Text(
                    l10n.nextLevelButton,
                    style: AppTextStyles.buttonLarge.copyWith(fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Replay & Home Row Buttons
            Row(
              children: [
                Expanded(
                  child: BouncyButton(
                    height: 50,
                    backgroundColor: AppColors.surfaceWarm,
                    shadowColor: AppColors.woodBorder,
                    borderRadius: BorderRadius.circular(18),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onReplay();
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.refresh_rounded, color: AppColors.textPrimary, size: 20),
                          const SizedBox(width: 6),
                          Text(l10n.replayButton, style: AppTextStyles.titleSmall.copyWith(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BouncyButton(
                    height: 50,
                    backgroundColor: AppColors.surfaceWarm,
                    shadowColor: AppColors.woodBorder,
                    borderRadius: BorderRadius.circular(18),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onHome();
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.home_rounded, color: AppColors.textPrimary, size: 20),
                          const SizedBox(width: 6),
                          Text(l10n.homeButton, style: AppTextStyles.titleSmall.copyWith(fontSize: 16)),
                        ],
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
