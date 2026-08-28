import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/locale_controller.dart';
import '../../../../core/widgets/pastel_app_bar.dart';
import '../../labyrinth_game/presentation/labyrinth_levels_screen.dart';
import '../../number_bonds_game/presentation/levels_screen.dart';
import '../../trampoline_game/presentation/trampoline_menu_screen.dart';
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
    final l10n = AppLocalizations.of(context);

    final numberBondsGame = GameInfo(
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

    final labyrinthGame = GameInfo(
      id: 'labyrinth_explorer',
      getTitle: (ctx) => AppLocalizations.of(ctx).strings.gameLabyrinthTitle,
      getSubtitle: (ctx) =>
          AppLocalizations.of(ctx).strings.gameLabyrinthSubtitle,
      imagePath: 'assets/images/tile_labyrinth.jpg',
      getBadges: [
        (ctx) => AppLocalizations.of(ctx).strings.badgeMaze,
        (ctx) => AppLocalizations.of(ctx).strings.badgeRandom,
        (ctx) => AppLocalizations.of(ctx).strings.badgeLives,
      ],
      accentColor: const Color(0xFFFFD8A8),
      shadowColor: const Color(0xFFE8590C),
    );

    final trampolineGame = GameInfo(
      id: 'trampoline_jumper',
      getTitle: (ctx) => AppLocalizations.of(ctx).strings.gameTrampolineTitle,
      getSubtitle: (ctx) =>
          AppLocalizations.of(ctx).strings.gameTrampolineSubtitle,
      imagePath: 'assets/images/tile_trampoline.jpg',
      getBadges: [
        (ctx) => AppLocalizations.of(ctx).strings.badgeArcade,
        (ctx) => AppLocalizations.of(ctx).strings.badgePhysics,
        (ctx) => AppLocalizations.of(ctx).strings.badgeRandom,
      ],
      accentColor: const Color(0xFFC3FAE8),
      shadowColor: const Color(0xFF0CA678),
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
                game: numberBondsGame,
                onPlay: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LevelsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              GameTileCard(
                game: labyrinthGame,
                onPlay: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LabyrinthLevelsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              GameTileCard(
                game: trampolineGame,
                onPlay: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TrampolineMenuScreen(),
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
