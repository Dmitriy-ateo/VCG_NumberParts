import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/storage/progress_repository.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../data/levels_data.dart';
import '../domain/models/level_data.dart';
import 'game_screen.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  final ProgressRepository _repository = ProgressRepository();
  int _unlockedLevel = 1;
  Map<int, int> _starsMap = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final unlocked = await _repository.getUnlockedLevel();
    final stars = <int, int>{};
    for (int i = 1; i <= LevelsData.allLevels.length; i++) {
      stars[i] = await _repository.getStarsForLevel(i);
    }

    if (mounted) {
      setState(() {
        _unlockedLevel = unlocked;
        _starsMap = stars;
      });
    }
  }

  void _openLevel(LevelData level) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NumberBondsGameScreen(level: level),
      ),
    );
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context).strings;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  BouncyButton(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    backgroundColor: AppColors.surfaceWarm,
                    shadowColor: AppColors.woodBorder,
                    borderRadius: BorderRadius.circular(16),
                    bevelHeight: 3.5,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      l10n.selectLevelTitle,
                      style: AppTextStyles.titleMedium,
                    ),
                  ),
                ],
              ),
            ),

            // Grid of 12 Level Stepping Stones
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.88,
                ),
                itemCount: LevelsData.allLevels.length,
                itemBuilder: (context, index) {
                  final level = LevelsData.allLevels[index];
                  final isUnlocked = level.levelNumber <= _unlockedLevel;
                  final stars = _starsMap[level.levelNumber] ?? 0;

                  return _buildLevelCard(
                    context,
                    level: level,
                    isUnlocked: isUnlocked,
                    stars: stars,
                    l10n: l10n,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context, {
    required LevelData level,
    required bool isUnlocked,
    required int stars,
    required AppStrings l10n,
  }) {
    return GestureDetector(
      onTap: isUnlocked ? () => _openLevel(level) : null,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? AppColors.backgroundCard : const Color(0xFFEADBCE),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isUnlocked ? AppColors.woodBorder : AppColors.woodBorder.withAlpha(80),
            width: 2.5,
          ),
          boxShadow: isUnlocked
              ? const [
                  BoxShadow(
                    color: AppColors.shadowWarm,
                    offset: Offset(0, 6),
                    blurRadius: 10,
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Level Number Circle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isUnlocked ? AppColors.pastelPeach : const Color(0xFFC7B3A2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUnlocked ? AppColors.pastelPeachDark : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(
                child: isUnlocked
                    ? Text(
                        '${level.levelNumber}',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textWhite,
                          fontSize: 22,
                        ),
                      )
                    : const Icon(
                        Icons.lock_rounded,
                        color: Color(0xFF7A6556),
                        size: 24,
                      ),
              ),
            ),
            const SizedBox(height: 8),

            // Target Sum Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: isUnlocked ? AppColors.pastelYellow.withAlpha(150) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${l10n.targetLabel}: ${level.targetSum}',
                style: AppTextStyles.badge.copyWith(
                  color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Earned Stars
            if (isUnlocked)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (starIndex) {
                  return Text(
                    starIndex < stars ? '⭐' : '☆',
                    style: TextStyle(
                      fontSize: 14,
                      color: starIndex < stars ? AppColors.pastelYellowDark : AppColors.textMuted,
                    ),
                  );
                }),
              )
            else
              Text(
                '🔒',
                style: TextStyle(fontSize: 14, color: AppColors.textMuted.withAlpha(120)),
              ),
          ],
        ),
      ),
    );
  }
}
