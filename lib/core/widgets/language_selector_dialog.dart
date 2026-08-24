import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../l10n/locale_controller.dart';
import 'bouncy_button.dart';

class LanguageSelectorDialog extends StatelessWidget {
  final LocaleController localeController;

  const LanguageSelectorDialog({
    super.key,
    required this.localeController,
  });

  static Future<void> show(BuildContext context, LocaleController controller) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Language',
      barrierColor: Colors.black.withAlpha(80),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return LanguageSelectorDialog(localeController: controller);
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim1.value),
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context).strings;
    final currentCode = localeController.locale.languageCode;

    final languages = [
      {'code': 'uk', 'name': l10n.languageUk, 'flag': '🇺🇦', 'color': AppColors.pastelYellow},
      {'code': 'en', 'name': l10n.languageEn, 'flag': '🇬🇧', 'color': AppColors.pastelSky},
      {'code': 'sl', 'name': l10n.languageSl, 'flag': '🇸🇮', 'color': AppColors.pastelSage},
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.woodBorder.withAlpha(120), width: 3),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowWarmStrong,
              offset: Offset(0, 12),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.chooseLanguage,
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...languages.map((lang) {
              final isSelected = currentCode == lang['code'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BouncyButton(
                  height: 58,
                  backgroundColor: isSelected
                      ? AppColors.pastelPeach
                      : AppColors.surfaceWarm,
                  shadowColor: isSelected
                      ? AppColors.pastelPeachDark
                      : AppColors.woodBorder,
                  borderRadius: BorderRadius.circular(18),
                  onPressed: () {
                    localeController.setLocale(Locale(lang['code'] as String));
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: (lang['color'] as Color).withAlpha(100),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          lang['flag'] as String,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          lang['name'] as String,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: isSelected
                                ? AppColors.textWhite
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.textWhite,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
