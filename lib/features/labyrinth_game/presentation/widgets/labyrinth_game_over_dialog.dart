import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/bouncy_button.dart';

class LabyrinthGameOverDialog extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onHome;

  const LabyrinthGameOverDialog({
    super.key,
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
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFE3E3),
                border: Border.all(color: const Color(0xFFFA5252), width: 3),
              ),
              child: const Center(
                child: Text('💔', style: TextStyle(fontSize: 38)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.strings.labyrinthGameOverTitle,
              style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.strings.labyrinthGameOverSubtitle,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            BouncyButton(
              onPressed: onRetry,
              backgroundColor: AppColors.pastelPeach,
              shadowColor: AppColors.pastelPeachDark,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.strings.tryAgainButton,
                      style: AppTextStyles.buttonLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            BouncyButton(
              onPressed: onHome,
              backgroundColor: const Color(0xFFFFE3B8),
              shadowColor: const Color(0xFFDDA668),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.strings.homeButton,
                      style: AppTextStyles.buttonLarge.copyWith(
                        fontSize: 15,
                        color: const Color(0xFF6E4018),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
