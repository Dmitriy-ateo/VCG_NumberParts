import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/audio/sound_manager.dart';
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
  LevelCategory _selectedCategory = LevelCategory.classic;
  int _unlockedClassic = 1;
  int _unlockedAdvanced = 1;
  Map<int, int> _classicStars = {};
  Map<int, int> _advancedStars = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final unlockedClassic = await _repository.getUnlockedLevel(LevelCategory.classic);
    final unlockedAdvanced = await _repository.getUnlockedLevel(LevelCategory.advanced);

    final classicStars = <int, int>{};
    for (int i = 1; i <= LevelsData.classicLevels.length; i++) {
      classicStars[i] = await _repository.getStarsForLevel(i, LevelCategory.classic);
    }

    final advancedStars = <int, int>{};
    for (int i = 1; i <= LevelsData.advancedLevels.length; i++) {
      advancedStars[i] = await _repository.getStarsForLevel(i, LevelCategory.advanced);
    }

    if (mounted) {
      setState(() {
        _unlockedClassic = unlockedClassic;
        _unlockedAdvanced = unlockedAdvanced;
        _classicStars = classicStars;
        _advancedStars = advancedStars;
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
    final currentLevels = _selectedCategory == LevelCategory.classic
        ? LevelsData.classicLevels
        : LevelsData.advancedLevels;
    final currentUnlocked = _selectedCategory == LevelCategory.classic
        ? _unlockedClassic
        : _unlockedAdvanced;
    final currentStarsMap = _selectedCategory == LevelCategory.classic
        ? _classicStars
        : _advancedStars;

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

            // Mode Category Switcher (Classic 4-10 vs Advanced Equations)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWarm,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.woodBorder.withAlpha(120), width: 1.5),
                ),
                child: Row(
                  children: [
                    // Classic Tab
                    Expanded(
                      child: _buildCategoryTab(
                        title: l10n.tabClassic,
                        isSelected: _selectedCategory == LevelCategory.classic,
                        activeColor: AppColors.pastelPeach,
                        activeShadow: AppColors.pastelPeachDark,
                        onTap: () {
                          SoundManager.instance.playMenuClickSound();
                          setState(() => _selectedCategory = LevelCategory.classic);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Advanced Equations Tab
                    Expanded(
                      child: _buildCategoryTab(
                        title: l10n.tabAdvanced,
                        isSelected: _selectedCategory == LevelCategory.advanced,
                        activeColor: AppColors.pastelYellow,
                        activeShadow: AppColors.pastelYellowDark,
                        onTap: () {
                          SoundManager.instance.playMenuClickSound();
                          setState(() => _selectedCategory = LevelCategory.advanced);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Grid of Level Stepping Stones
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.88,
                ),
                itemCount: currentLevels.length,
                itemBuilder: (context, index) {
                  final level = currentLevels[index];
                  final isUnlocked = level.levelNumber <= currentUnlocked;
                  final stars = currentStarsMap[level.levelNumber] ?? 0;

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

  Widget _buildCategoryTab({
    required String title,
    required bool isSelected,
    required Color activeColor,
    required Color activeShadow,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: activeShadow, width: 1.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeShadow.withAlpha(90),
                    offset: const Offset(0, 3),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
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
    final hasEquation = level.targetEquation != null;

    return GestureDetector(
      onTap: isUnlocked ? () => _openLevel(level) : null,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? AppColors.backgroundCard : const Color(0xFFEADBCE),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isUnlocked ? AppColors.woodBorder : AppColors.woodBorder.withAlpha(80),
            width: 2.2,
          ),
          boxShadow: isUnlocked
              ? const [
                  BoxShadow(
                    color: AppColors.shadowWarm,
                    offset: Offset(0, 5),
                    blurRadius: 8,
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? (hasEquation ? AppColors.pastelYellow : AppColors.pastelPeach)
                    : const Color(0xFFC7B3A2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUnlocked
                      ? (hasEquation ? AppColors.pastelYellowDark : AppColors.pastelPeachDark)
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: (hasEquation ? AppColors.pastelYellowDark : AppColors.pastelPeachDark)
                              .withAlpha(80),
                          offset: const Offset(0, 2),
                          blurRadius: 3,
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: isUnlocked
                    ? Text(
                        '${level.levelNumber}',
                        style: GoogleFonts.fredoka(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : const Icon(
                        Icons.lock_rounded,
                        color: Color(0xFF7A6556),
                        size: 22,
                      ),
              ),
            ),
            const SizedBox(height: 8),

            // Target Pill (Equation or Direct Sum)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? (hasEquation
                        ? const Color(0xFFFFF1C2)
                        : AppColors.pastelYellow.withAlpha(140))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isUnlocked
                    ? Border.all(
                        color: hasEquation
                            ? const Color(0xFFE5B540)
                            : AppColors.pastelYellowDark.withAlpha(120),
                        width: 1.0,
                      )
                    : null,
              ),
              child: Text(
                hasEquation
                    ? '${level.targetEquation}'
                    : '${l10n.targetLabel}: ${level.targetSum}',
                style: GoogleFonts.fredoka(
                  color: isUnlocked ? const Color(0xFF6B3A16) : AppColors.textMuted,
                  fontSize: hasEquation ? 14 : 13,
                  fontWeight: FontWeight.w700,
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
                      fontSize: 13,
                      color: starIndex < stars ? AppColors.pastelYellowDark : AppColors.textMuted,
                    ),
                  );
                }),
              )
            else
              Text(
                '🔒',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted.withAlpha(120)),
              ),
          ],
        ),
      ),
    );
  }
}
