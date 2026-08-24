import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../l10n/locale_controller.dart';
import 'bouncy_button.dart';
import 'language_selector_dialog.dart';

class PastelAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LocaleController localeController;

  const PastelAppBar({
    super.key,
    required this.localeController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  String _getFlag(String code) {
    switch (code) {
      case 'uk':
        return '🇺🇦';
      case 'sl':
        return '🇸🇮';
      case 'en':
      default:
        return '🇬🇧';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            // App Title Pill / Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.woodBorder.withAlpha(140), width: 2.5),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowWarm,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('📐', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Text('NumberParts', style: AppTextStyles.titleSmall),
                ],
              ),
            ),
            const Spacer(),

            // Stars Counter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.pastelYellow.withAlpha(140),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.pastelYellowDark.withAlpha(150), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowWarm,
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    '12',
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Language Switcher Button
            ListenableBuilder(
              listenable: localeController,
              builder: (context, _) {
                final flag = _getFlag(localeController.locale.languageCode);
                return BouncyButton(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  backgroundColor: AppColors.surfaceWarm,
                  shadowColor: AppColors.woodBorder,
                  borderRadius: BorderRadius.circular(20),
                  bevelHeight: 3.5,
                  onPressed: () => LanguageSelectorDialog.show(context, localeController),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
