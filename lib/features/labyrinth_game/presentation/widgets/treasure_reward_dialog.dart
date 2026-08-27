import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/bouncy_button.dart';

class TreasureRewardDialog extends StatelessWidget {
  final int stars;
  final VoidCallback onNextLevel;
  final VoidCallback onReplay;
  final VoidCallback onHome;

  const TreasureRewardDialog({
    super.key,
    required this.stars,
    required this.onNextLevel,
    required this.onReplay,
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
          border: Border.all(color: const Color(0xFFE2C9A5), width: 3.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              offset: const Offset(0, 12),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Glowing Treasure Chest Icon
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFE0A3),
                border: Border.all(color: const Color(0xFFE8590C), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF922B).withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🏆', style: TextStyle(fontSize: 44)),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              l10n.strings.treasureFoundTitle,
              style: AppTextStyles.titleLarge.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              l10n.strings.treasureFoundSubtitle,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Stars Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      i < stars ? '⭐' : '☆',
                      style: TextStyle(
                        fontSize: 34,
                        color: i < stars ? const Color(0xFFFFD43B) : Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Action Buttons
            BouncyButton(
              onPressed: onNextLevel,
              backgroundColor: AppColors.pastelSage,
              shadowColor: AppColors.pastelSageDark,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.strings.nextLevelButton,
                      style: AppTextStyles.buttonLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: BouncyButton(
                    onPressed: onReplay,
                    backgroundColor: const Color(0xFFFFE3B8),
                    shadowColor: const Color(0xFFDDA668),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        l10n.strings.replayButton,
                        style: AppTextStyles.buttonLarge.copyWith(
                          fontSize: 15,
                          color: const Color(0xFF6E4018),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BouncyButton(
                    onPressed: onHome,
                    backgroundColor: const Color(0xFFFFE3B8),
                    shadowColor: const Color(0xFFDDA668),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        l10n.strings.homeButton,
                        style: AppTextStyles.buttonLarge.copyWith(
                          fontSize: 15,
                          color: const Color(0xFF6E4018),
                        ),
                        textAlign: TextAlign.center,
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
