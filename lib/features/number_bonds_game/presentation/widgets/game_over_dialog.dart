import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/bouncy_button.dart';

class GameOverDialog extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onHome;

  const GameOverDialog({
    super.key,
    required this.onRetry,
    required this.onHome,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onRetry,
    required VoidCallback onHome,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'GameOver',
      barrierColor: Colors.black.withAlpha(90),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return GameOverDialog(
          onRetry: onRetry,
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
        constraints: const BoxConstraints(maxWidth: 380),
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
            // Sad/Encouraging Mascot Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.pastelRose.withAlpha(120),
                shape: BoxShape.circle,
              ),
              child: const Text('🦊', style: TextStyle(fontSize: 44)),
            ),
            const SizedBox(height: 16),

            // Title & Subtitle
            Text(
              l10n.gameOverTitle,
              style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.gameOverSubtitle,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Try Again Button
            SizedBox(
              width: double.infinity,
              child: BouncyButton(
                height: 58,
                backgroundColor: AppColors.pastelPeach,
                shadowColor: AppColors.pastelPeachDark,
                borderRadius: BorderRadius.circular(20),
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.replay_rounded, color: AppColors.textWhite, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        l10n.tryAgainButton,
                        style: AppTextStyles.buttonLarge.copyWith(fontSize: 19),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Back to Menu Button
            SizedBox(
              width: double.infinity,
              child: BouncyButton(
                height: 48,
                backgroundColor: AppColors.surfaceWarm,
                shadowColor: AppColors.woodBorder,
                borderRadius: BorderRadius.circular(18),
                onPressed: () {
                  Navigator.of(context).pop();
                  onHome();
                },
                child: Center(
                  child: Text(
                    l10n.homeButton,
                    style: AppTextStyles.titleSmall.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
