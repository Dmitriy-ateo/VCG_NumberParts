import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/audio/sound_manager.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/locale_controller.dart';
import '../../../../core/widgets/pastel_app_bar.dart';
import '../../labyrinth_game/presentation/labyrinth_levels_screen.dart';
import '../../number_bonds_game/presentation/levels_screen.dart';
import '../../trampoline_game/presentation/trampoline_menu_screen.dart';
import '../domain/game_info.dart';
import 'widgets/game_tile_card.dart';
import 'widgets/welcome_banner.dart';

class HomeScreen extends StatefulWidget {
  final LocaleController localeController;

  const HomeScreen({
    super.key,
    required this.localeController,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SoundManager.instance.startMenuMusic();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final numberBondsGame = GameInfo(
      id: 'number_bonds',
      getTitle: (ctx) => AppLocalizations.of(ctx).strings.gameNumberBondsTitle,
      getSubtitle: (ctx) =>
          AppLocalizations.of(ctx).strings.gameNumberBondsSubtitle,
      imagePath: 'assets/images/tile_number_bonds.jpg',
      badges: [
        GameBadge(
          icon: '🎓',
          getLabel: (ctx) => AppLocalizations.of(ctx).strings.badgeGrades,
          bgColor: AppColors.pastelYellow.withAlpha(140),
          borderColor: AppColors.pastelYellowDark.withAlpha(160),
        ),
        GameBadge(
          icon: '❤️',
          getLabel: (ctx) => AppLocalizations.of(ctx).strings.badgeLives,
          bgColor: AppColors.pastelRose.withAlpha(140),
          borderColor: AppColors.pastelRoseDark.withAlpha(160),
        ),
        GameBadge(
          icon: '🪵',
          getLabel: (ctx) => AppLocalizations.of(ctx).strings.badgeWood,
          bgColor: AppColors.pastelSage.withAlpha(140),
          borderColor: AppColors.pastelSageDark.withAlpha(160),
        ),
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
      badges: [
        GameBadge(
          icon: '🎓',
          getLabel: (ctx) => AppLocalizations.of(ctx).strings.badgeGrades,
          bgColor: AppColors.pastelYellow.withAlpha(140),
          borderColor: AppColors.pastelYellowDark.withAlpha(160),
        ),
        GameBadge(
          icon: '🚪',
          getLabel: (ctx) => AppLocalizations.of(ctx).strings.badgeMaze,
          bgColor: const Color(0xFFFFD8A8).withAlpha(140),
          borderColor: const Color(0xFFE8590C).withAlpha(160),
        ),
        GameBadge(
          icon: '🎲',
          getLabel: (ctx) => AppLocalizations.of(ctx).strings.badgeRandom,
          bgColor: const Color(0xFFD0EBFF).withAlpha(140),
          borderColor: const Color(0xFF1971C2).withAlpha(160),
        ),
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
      badges: [
        GameBadge(
          icon: '🎓',
          getLabel: (ctx) => AppLocalizations.of(ctx).strings.badgeGrades,
          bgColor: AppColors.pastelYellow.withAlpha(140),
          borderColor: AppColors.pastelYellowDark.withAlpha(160),
        ),
        GameBadge(
          icon: '🕹️',
          getLabel: (ctx) => AppLocalizations.of(ctx).strings.badgeArcade,
          bgColor: const Color(0xFFFFD8A8).withAlpha(140),
          borderColor: const Color(0xFFE8590C).withAlpha(160),
        ),
        GameBadge(
          icon: '🤸',
          getLabel: (ctx) => AppLocalizations.of(ctx).strings.badgePhysics,
          bgColor: const Color(0xFFC3FAE8).withAlpha(140),
          borderColor: const Color(0xFF0CA678).withAlpha(160),
        ),
      ],
      accentColor: const Color(0xFFC3FAE8),
      shadowColor: const Color(0xFF0CA678),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PastelAppBar(localeController: widget.localeController),
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
