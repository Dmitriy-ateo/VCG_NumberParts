import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../features/home/domain/grade_filter_controller.dart';
import '../audio/sound_manager.dart';
import '../l10n/app_localizations.dart';
import '../l10n/locale_controller.dart';
import 'bouncy_button.dart';

class SettingsDialog extends StatelessWidget {
  final LocaleController localeController;
  final GradeFilterController? gradeFilterController;

  const SettingsDialog({
    super.key,
    required this.localeController,
    this.gradeFilterController,
  });

  static Future<void> show(
    BuildContext context,
    LocaleController controller, {
    GradeFilterController? gradeFilterController,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Settings',
      barrierColor: Colors.black.withAlpha(90),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return SettingsDialog(
          localeController: controller,
          gradeFilterController: gradeFilterController,
        );
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
      {'code': 'uk', 'name': l10n.languageUk, 'flag': '🇺🇦'},
      {'code': 'en', 'name': l10n.languageEn, 'flag': '🇬🇧'},
      {'code': 'sl', 'name': l10n.languageSl, 'flag': '🇸🇮'},
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.woodBorder.withAlpha(140), width: 3),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.pastelYellow.withAlpha(120),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('⚙️', style: TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.settingsTitle,
                    style: AppTextStyles.titleMedium,
                  ),
                ),
                // Close button
                GestureDetector(
                  onTap: () {
                    SoundManager.instance.playMenuClickSound();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWarm,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.woodBorder.withAlpha(100)),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Music Toggle Card
            ValueListenableBuilder<bool>(
              valueListenable: SoundManager.instance.isMusicEnabled,
              builder: (context, isMusic, _) {
                return _buildSettingToggle(
                  title: l10n.musicLabel,
                  subtitle: isMusic ? 'Playing' : 'Muted',
                  iconText: isMusic ? '🎵' : '🔇',
                  isActive: isMusic,
                  onTap: () => SoundManager.instance.toggleMusic(),
                );
              },
            ),
            const SizedBox(height: 12),

            // Sound Effects Toggle Card
            ValueListenableBuilder<bool>(
              valueListenable: SoundManager.instance.isSfxEnabled,
              builder: (context, isSfx, _) {
                return _buildSettingToggle(
                  title: l10n.soundEffectsLabel,
                  subtitle: isSfx ? 'Enabled' : 'Muted',
                  iconText: isSfx ? '🔔' : '🔕',
                  isActive: isSfx,
                  onTap: () => SoundManager.instance.toggleSfx(),
                );
              },
            ),
            // Grade Filter Section (if controller provided)
            if (gradeFilterController != null) ...[
              const SizedBox(height: 22),
              Text(
                l10n.filterByGrade,
                style: AppTextStyles.titleSmall.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),
              ListenableBuilder(
                listenable: gradeFilterController!,
                builder: (context, _) {
                  final activeFilter = gradeFilterController!.selectedFilter;
                  final filterOptions = [
                    {'opt': GradeFilterOption.all, 'label': l10n.filterAll},
                    {'opt': GradeFilterOption.grades0to1, 'label': l10n.filterGrades0to1},
                    {'opt': GradeFilterOption.grades1to2, 'label': l10n.filterGrades1to2},
                  ];

                  return Row(
                    children: filterOptions.map((item) {
                      final opt = item['opt'] as GradeFilterOption;
                      final isSelected = activeFilter == opt;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: BouncyButton(
                            height: 46,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            backgroundColor: isSelected
                                ? AppColors.pastelYellow
                                : AppColors.surfaceWarm,
                            shadowColor: isSelected
                                ? AppColors.pastelYellowDark
                                : AppColors.woodBorder,
                            borderRadius: BorderRadius.circular(16),
                            bevelHeight: 3.0,
                            onPressed: () {
                              gradeFilterController!.setFilter(opt);
                            },
                            child: Center(
                              child: Text(
                                item['label'] as String,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.badge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],

            const SizedBox(height: 22),

            // Language Selector Section
            Text(
              l10n.languageLabel,
              style: AppTextStyles.titleSmall.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),

            Row(
              children: languages.map((lang) {
                final isSelected = currentCode == lang['code'];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: BouncyButton(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      backgroundColor: isSelected
                          ? AppColors.pastelPeach
                          : AppColors.surfaceWarm,
                      shadowColor: isSelected
                          ? AppColors.pastelPeachDark
                          : AppColors.woodBorder,
                      borderRadius: BorderRadius.circular(16),
                      bevelHeight: 3.5,
                      onPressed: () {
                        localeController.setLocale(Locale(lang['code']!));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lang['flag']!,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              lang['code']!.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.badge.copyWith(
                                color: isSelected
                                    ? AppColors.textWhite
                                    : AppColors.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingToggle({
    required String title,
    required String subtitle,
    required String iconText,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        SoundManager.instance.playMenuClickSound();
        onTap();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceWarm,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.pastelYellowDark.withAlpha(120)
                : AppColors.woodBorder.withAlpha(80),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.pastelYellow.withAlpha(130)
                    : AppColors.woodBorder.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Text(iconText, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: isActive,
              activeColor: AppColors.pastelPeachDark,
              activeTrackColor: AppColors.pastelPeach.withAlpha(140),
              onChanged: (_) {
                SoundManager.instance.playMenuClickSound();
                onTap();
              },
            ),
          ],
        ),
      ),
    );
  }
}
