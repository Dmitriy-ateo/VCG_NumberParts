import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../l10n/locale_controller.dart';
import '../storage/progress_repository.dart';
import 'bouncy_button.dart';
import 'settings_dialog.dart';

class PastelAppBar extends StatefulWidget implements PreferredSizeWidget {
  final LocaleController localeController;

  const PastelAppBar({
    super.key,
    required this.localeController,
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

            // Right: Settings Icon Button
            BouncyButton(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              backgroundColor: AppColors.surfaceWarm,
              shadowColor: AppColors.woodBorder,
              borderRadius: BorderRadius.circular(20),
              bevelHeight: 3.5,
              onPressed: () {
                SettingsDialog.show(context, widget.localeController).then((_) {
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
      ),
    );
  }
}
