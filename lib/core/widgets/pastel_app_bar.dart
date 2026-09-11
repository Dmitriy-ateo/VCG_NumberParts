import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../features/home/domain/grade_filter_controller.dart';
import '../l10n/app_localizations.dart';
import '../l10n/locale_controller.dart';
import '../storage/progress_repository.dart';
import 'bouncy_button.dart';
import 'settings_dialog.dart';

class PastelAppBar extends StatefulWidget implements PreferredSizeWidget {
  final LocaleController localeController;
  final GradeFilterController? gradeFilterController;

  const PastelAppBar({
    super.key,
    required this.localeController,
    this.gradeFilterController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  State<PastelAppBar> createState() => _PastelAppBarState();
}

class _PastelAppBarState extends State<PastelAppBar> {
  final ProgressRepository _progressRepository = ProgressRepository();
  int _totalStars = 12;

  @override
  void initState() {
    super.initState();
    _loadStars();
  }

  Future<void> _loadStars() async {
    final stars = await _progressRepository.getAllTotalStars();
    if (mounted) {
      setState(() {
        // If the user has earned stars use them, otherwise show a welcoming starter score
        _totalStars = stars > 0 ? stars : 12;
      });
    }
  }

  void _showGradeFilterDialog(BuildContext context, GradeFilterController controller) {
    final l10n = AppLocalizations.of(context).strings;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'GradeFilter',
      barrierColor: Colors.black.withAlpha(90),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: AppColors.woodBorder.withAlpha(150),
                width: 3,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowWarmStrong,
                  offset: Offset(0, 10),
                  blurRadius: 25,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '🎓 ${l10n.filterByGrade}',
                        style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) {
                    final active = controller.selectedFilter;
                    final options = [
                      {'opt': GradeFilterOption.all, 'label': l10n.filterAll, 'icon': '🌟'},
                      {'opt': GradeFilterOption.grades0to1, 'label': l10n.filterGrades0to1, 'icon': '🎒'},
                      {'opt': GradeFilterOption.grades1to2, 'label': l10n.filterGrades1to2, 'icon': '📚'},
                    ];

                    return Column(
                      children: options.map((item) {
                        final opt = item['opt'] as GradeFilterOption;
                        final isSelected = active == opt;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: BouncyButton(
                            height: 52,
                            backgroundColor: isSelected
                                ? AppColors.pastelYellow
                                : AppColors.surfaceWarm,
                            shadowColor: isSelected
                                ? AppColors.pastelYellowDark
                                : AppColors.woodBorder,
                            borderRadius: BorderRadius.circular(18),
                            bevelHeight: 3.5,
                            onPressed: () {
                              controller.setFilter(opt);
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              children: [
                                const SizedBox(width: 14),
                                Text(item['icon'] as String, style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item['label'] as String,
                                    style: AppTextStyles.badge.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 14),
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.pastelPeachDark,
                                      size: 22,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            // Left: App Logo
            Image.asset(
              'assets/images/heroma_header_icon.png',
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),

            const Spacer(),

            // Middle: Stars Counter / Score
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.pastelYellow.withAlpha(140),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.pastelYellowDark.withAlpha(150),
                  width: 2,
                ),
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
                    '$_totalStars',
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Right: Filter & Settings Buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.gradeFilterController != null) ...[
                  ListenableBuilder(
                    listenable: widget.gradeFilterController!,
                    builder: (context, _) {
                      final controller = widget.gradeFilterController!;
                      final isFiltered = controller.selectedFilter != GradeFilterOption.all;
                      String badgeText = '';
                      if (controller.selectedFilter == GradeFilterOption.grades0to1) {
                        badgeText = '0–1';
                      } else if (controller.selectedFilter == GradeFilterOption.grades1to2) {
                        badgeText = '1–2';
                      }

                      return BouncyButton(
                        height: 48,
                        padding: EdgeInsets.symmetric(
                          horizontal: isFiltered ? 10 : 12,
                          vertical: 8,
                        ),
                        backgroundColor: isFiltered
                            ? AppColors.pastelYellow
                            : AppColors.surfaceWarm,
                        shadowColor: isFiltered
                            ? AppColors.pastelYellowDark
                            : AppColors.woodBorder,
                        borderRadius: BorderRadius.circular(20),
                        bevelHeight: 3.5,
                        onPressed: () {
                          _showGradeFilterDialog(context, controller);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🎓', style: TextStyle(fontSize: 18)),
                            if (isFiltered) ...[
                              const SizedBox(width: 4),
                              Text(
                                badgeText,
                                style: AppTextStyles.badge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
                // Settings Icon Button
                BouncyButton(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                  backgroundColor: AppColors.surfaceWarm,
                  shadowColor: AppColors.woodBorder,
                  borderRadius: BorderRadius.circular(20),
                  bevelHeight: 3.5,
                  onPressed: () {
                    SettingsDialog.show(
                      context,
                      widget.localeController,
                      gradeFilterController: widget.gradeFilterController,
                    ).then((_) {
                      _loadStars();
                    });
                  },
                  child: const Icon(
                    Icons.settings_rounded,
                    color: AppColors.textPrimary,
                    size: 24,
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

