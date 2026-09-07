import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/audio/sound_manager.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/storage/progress_repository.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../../../core/widgets/music_toggle_button.dart';
import '../domain/logic/miner_levels_catalog.dart';
import '../domain/models/miner_level_data.dart';
import 'fox_miner_game_screen.dart';

class FoxMinerLevelsScreen extends StatefulWidget {
  const FoxMinerLevelsScreen({super.key});

  @override
  State<FoxMinerLevelsScreen> createState() => _FoxMinerLevelsScreenState();
}

class _FoxMinerLevelsScreenState extends State<FoxMinerLevelsScreen> {
  final ProgressRepository _repository = ProgressRepository();
  int _unlockedLevel = 1;
  Map<int, int> _levelStars = {};
  int _totalStars = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    SoundManager.instance.startMenuMusic();
  }

  Future<void> _loadProgress() async {
    final unlocked = await _repository.getFoxMinerUnlockedLevel();
    final starsMap = <int, int>{};
    for (int i = 1; i <= MinerLevelsCatalog.allLevels.length; i++) {
      starsMap[i] = await _repository.getFoxMinerStarsForLevel(i);
    }
    final total = await _repository.getFoxMinerTotalStars(MinerLevelsCatalog.allLevels.length);

    if (mounted) {
      setState(() {
        _unlockedLevel = unlocked;
        _levelStars = starsMap;
        _totalStars = total;
      });
    }
  }

  void _openLevel(MinerLevelData level) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FoxMinerGameScreen(level: level),
      ),
    );
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final strings = l10n.strings;
    final levels = MinerLevelsCatalog.allLevels;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: BouncyButton(
              onPressed: () => Navigator.of(context).pop(),
              backgroundColor: const Color(0xFFFFF3DB),
              shadowColor: const Color(0xFFE8C88A),
              padding: EdgeInsets.zero,
              height: 40,
              borderRadius: BorderRadius.circular(12),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF8A5A2B),
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          strings.selectLevelTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontSize: 20,
            color: AppColors.textPrimary,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: MusicToggleButton(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Card with Game Title and Total Stars
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.pastelPeachDark, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pastelPeachDark.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.pastelPeach.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('⛏️', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                strings.gameFoxMinerTitle,
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontSize: 18,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.pastelYellow.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.pastelYellowDark, width: 1),
                                ),
                                child: Text(
                                  strings.badgeGradesMiners,
                                  style: AppTextStyles.badge.copyWith(
                                    fontSize: 11,
                                    color: const Color(0xFF8A5A2B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            strings.gameFoxMinerSubtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.pastelYellow.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.pastelYellowDark, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Text('⭐', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 4),
                          Text(
                            '$_totalStars / ${levels.length * 3}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Grid of Levels
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.88,
                ),
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  final level = levels[index];
                  final isUnlocked = level.levelNumber <= _unlockedLevel;
                  final stars = _levelStars[level.levelNumber] ?? 0;

                  return _buildLevelTile(
                    context,
                    level: level,
                    isUnlocked: isUnlocked,
                    stars: stars,
                    strings: strings,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelTile(
    BuildContext context, {
    required MinerLevelData level,
    required bool isUnlocked,
    required int stars,
    required AppStrings strings,
  }) {
    return BouncyButton(
      onPressed: isUnlocked
          ? () => _openLevel(level)
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(strings.lockedLevel),
                  duration: const Duration(milliseconds: 900),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
      backgroundColor: isUnlocked ? Colors.white : const Color(0xFFE9ECEF),
      shadowColor: isUnlocked ? AppColors.pastelPeachDark : const Color(0xFFCED4DA),
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      borderRadius: BorderRadius.circular(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isUnlocked) ...[
            // Level Number
            Text(
              '${level.levelNumber}',
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 2),

            // Target Crystal Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF7950F2).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💎 ', style: TextStyle(fontSize: 10)),
                  Text(
                    '${level.targetNumber}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF5F3DC4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Stars earned
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (starIdx) {
                final earned = starIdx < stars;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5),
                  child: Text(
                    earned ? '⭐' : '☆',
                    style: TextStyle(
                      fontSize: 13,
                      color: earned ? const Color(0xFFFAB005) : Colors.grey.shade400,
                    ),
                  ),
                );
              }),
            ),
          ] else ...[
            // Locked state
            Icon(
              Icons.lock_rounded,
              size: 28,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 6),
            Text(
              '${level.levelNumber}',
              style: AppTextStyles.titleSmall.copyWith(
                fontSize: 16,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
