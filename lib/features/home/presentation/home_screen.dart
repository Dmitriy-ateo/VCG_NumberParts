import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/audio/sound_manager.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/l10n/locale_controller.dart';
import '../../../../core/widgets/bouncy_button.dart';
import '../../../../core/widgets/pastel_app_bar.dart';
import '../../fox_miner_game/presentation/fox_miner_levels_screen.dart';
import '../../labyrinth_game/presentation/labyrinth_levels_screen.dart';
import '../../number_bonds_game/presentation/levels_screen.dart';
import '../../trampoline_game/presentation/trampoline_menu_screen.dart';
import '../domain/game_info.dart';
import '../domain/grade_filter_controller.dart';
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
  final GradeFilterController _gradeFilterController = GradeFilterController();

  @override
  void initState() {
    super.initState();
    SoundManager.instance.startMenuMusic();
  }

  @override
  void dispose() {
    _gradeFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foxMinerGame = GameInfo(
      id: 'fox_miners',
      minGrade: 0,
      maxGrade: 1,
      getTitle: (ctx) => AppLocalizations.of(ctx).strings.gameFoxMinerTitle,
      getSubtitle: (ctx) =>
          AppLocalizations.of(ctx).strings.gameFoxMinerSubtitle,
      imagePath: 'assets/images/tile_fox_miners.jpg',
      badges: [
        GameBadge(
          icon: '🎓',
          getLabel: (ctx) => AppLocalizations.of(ctx).strings.badgeGradesMiners,
          bgColor: AppColors.pastelYellow.withAlpha(140),
          borderColor: AppColors.pastelYellowDark.withAlpha(160),
        ),
        GameBadge(
          icon: '⛏️',
          getLabel: (ctx) => AppLocalizations.of(ctx).strings.badgeMiner,
          bgColor: AppColors.pastelPeach.withAlpha(140),
          borderColor: AppColors.pastelPeachDark.withAlpha(160),
        ),
        GameBadge(
          icon: '💎',
          getLabel: (ctx) => AppLocalizations.of(ctx).strings.badgeTensSingles,
          bgColor: const Color(0xFFD0BFFF).withAlpha(140),
          borderColor: const Color(0xFF7048E8).withAlpha(160),
        ),
      ],
      accentColor: const Color(0xFFD0BFFF),
      shadowColor: const Color(0xFF7048E8),
      onPlay: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const FoxMinerLevelsScreen(),
          ),
        );
      },
    );

    final numberBondsGame = GameInfo(
      id: 'number_bonds',
      minGrade: 1,
      maxGrade: 2,
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
      onPlay: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LevelsScreen(),
          ),
        );
      },
    );

    final labyrinthGame = GameInfo(
      id: 'labyrinth_explorer',
      minGrade: 1,
      maxGrade: 2,
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
      onPlay: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LabyrinthLevelsScreen(),
          ),
        );
      },
    );

    final trampolineGame = GameInfo(
      id: 'trampoline_jumper',
      minGrade: 1,
      maxGrade: 2,
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
      onPlay: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const TrampolineMenuScreen(),
          ),
        );
      },
    );

    // Sort games ascending by grade from 0 to latest
    final allGames = [
      foxMinerGame,
      numberBondsGame,
      labyrinthGame,
      trampolineGame,
    ];

    allGames.sort((a, b) {
      final cmp = a.minGrade.compareTo(b.minGrade);
      if (cmp != 0) return cmp;
      return a.maxGrade.compareTo(b.maxGrade);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PastelAppBar(
        localeController: widget.localeController,
        gradeFilterController: _gradeFilterController,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const WelcomeBanner(),
              const SizedBox(height: 6),
              ListenableBuilder(
                listenable: _gradeFilterController,
                builder: (context, _) {
                  final filteredGames = allGames.where((game) {
                    return _gradeFilterController.matchesGrade(
                      minGrade: game.minGrade,
                      maxGrade: game.maxGrade,
                    );
                  }).toList();

                  if (filteredGames.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return Column(
                    children: filteredGames.map((game) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GameTileCard(game: game),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context).strings;
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: AppColors.woodBorder.withAlpha(120),
            width: 3,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowWarmStrong,
              offset: Offset(0, 10),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          children: [
            const Text('🦊🔍', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 14),
            Text(
              l10n.noGamesFound,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 18),
            BouncyButton(
              height: 48,
              backgroundColor: AppColors.pastelYellow,
              shadowColor: AppColors.pastelYellowDark,
              borderRadius: BorderRadius.circular(18),
              bevelHeight: 3.5,
              onPressed: () {
                _gradeFilterController.setFilter(GradeFilterOption.all);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.filterAll,
                  style: AppTextStyles.buttonMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

