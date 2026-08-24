import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/locale_controller.dart';
import '../../../../core/widgets/pastel_app_bar.dart';
import '../domain/game_info.dart';
import 'widgets/game_tile_card.dart';
import 'widgets/welcome_banner.dart';

class HomeScreen extends StatelessWidget {
  final LocaleController localeController;

  const HomeScreen({
    super.key,
    required this.localeController,
  });

  @override
  Widget build(BuildContext context) {
    final game = GameInfo(
      id: 'number_bonds',
      getTitle: (ctx) => AppLocalizations.of(ctx).strings.gameNumberBondsTitle,
      getSubtitle: (ctx) =>
          AppLocalizations.of(ctx).strings.gameNumberBondsSubtitle,
      imagePath: 'assets/images/tile_number_bonds.jpg',
      getBadges: [
        (ctx) => AppLocalizations.of(ctx).strings.badgeGrades,
        (ctx) => AppLocalizations.of(ctx).strings.badgeLives,
        (ctx) => AppLocalizations.of(ctx).strings.badgeWood,
      ],
      accentColor: AppColors.pastelPeach,
      shadowColor: AppColors.pastelPeachDark,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PastelAppBar(localeController: localeController),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const WelcomeBanner(),
              const SizedBox(height: 6),
              GameTileCard(
                game: game,
                onPlay: () {
                  // Scaffold notification for next step (game board implementation)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Text('🪵', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${AppLocalizations.of(context).strings.gameNumberBondsTitle} — Starting Game!',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.textPrimary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
