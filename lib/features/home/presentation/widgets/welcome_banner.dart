import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context).strings;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.woodBorder.withAlpha(120), width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowWarm,
            offset: Offset(0, 6),
            blurRadius: 14,
          ),
        ],
      ),
      child: Row(
        children: [
          // Mascot Image with gentle float animation
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/mascot_fox.jpg',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .moveY(begin: 0, end: -4, duration: 1800.ms, curve: Curves.easeInOutSine),
          const SizedBox(width: 18),

          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcomeTitle,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.welcomeSubtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
