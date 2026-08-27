import 'package:flutter/material.dart';
import 'package:number_parts/app/theme/app_colors.dart';
import 'package:number_parts/app/theme/app_text_styles.dart';
import 'package:number_parts/core/l10n/app_localizations.dart';
import 'package:number_parts/core/storage/progress_repository.dart';
import 'package:number_parts/core/widgets/bouncy_button.dart';
import 'package:number_parts/features/labyrinth_game/data/labyrinth_levels_data.dart';
import 'package:number_parts/features/labyrinth_game/domain/models/labyrinth_difficulty.dart';
import 'package:number_parts/features/labyrinth_game/domain/models/labyrinth_level.dart';
import 'package:number_parts/features/labyrinth_game/presentation/labyrinth_game_screen.dart';

class LabyrinthLevelsScreen extends StatefulWidget {
  const LabyrinthLevelsScreen({super.key});

  @override
  State<LabyrinthLevelsScreen> createState() => _LabyrinthLevelsScreenState();
}

class _LabyrinthLevelsScreenState extends State<LabyrinthLevelsScreen> {
  LabyrinthDifficulty _selectedDifficulty = LabyrinthDifficulty.simple;
  final ProgressRepository _progressRepository = ProgressRepository();

  int _unlockedLevel = 1;
  Map<int, int> _starsMap = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final diffKey = _selectedDifficulty.name;
    final unlocked = await _progressRepository.getLabyrinthUnlockedLevel(diffKey);
    final levels = LabyrinthLevelsData.getLevelsForDifficulty(_selectedDifficulty);

    final stars = <int, int>{};
    for (final level in levels) {
      stars[level.levelNumber] = await _progressRepository.getLabyrinthStarsForLevel(
        diffKey,
        level.levelNumber,
      );
    }

    if (mounted) {
      setState(() {
        _unlockedLevel = unlocked;
        _starsMap = stars;
      });
    }
  }

  void _onDifficultyChanged(LabyrinthDifficulty difficulty) {
    if (_selectedDifficulty == difficulty) return;
    setState(() {
      _selectedDifficulty = difficulty;
    });
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final levels = LabyrinthLevelsData.getLevelsForDifficulty(_selectedDifficulty);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP BAR ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  BouncyButton(
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: const Color(0xFFFFF3DB),
                    shadowColor: const Color(0xFFE8C88A),
                    padding: EdgeInsets.zero,
                    height: 44,
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20, color: Color(0xFF8A5A2B)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.strings.selectLevelTitle,
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                  ),
                ],
              ),
            ),

            // ── MODE SELECTOR TABS (Simple / Advanced / Hard) ───────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0E4D0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFDFCCAF), width: 2),
                ),
                child: Row(
                  children: [
                    _buildTabButton(
                      title: l10n.strings.tabSimple,
                      difficulty: LabyrinthDifficulty.simple,
                    ),
                    _buildTabButton(
                      title: l10n.strings.tabAdvanced,
                      difficulty: LabyrinthDifficulty.advanced,
                    ),
                    _buildTabButton(
                      title: l10n.strings.tabHard,
                      difficulty: LabyrinthDifficulty.hard,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── LEVELS GRID ────────────────────────────────────────────
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.25,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  final level = levels[index];
                  final isUnlocked = level.levelNumber <= _unlockedLevel;
                  final stars = _starsMap[level.levelNumber] ?? 0;

                  return _buildLevelCard(level, isUnlocked, stars);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required LabyrinthDifficulty difficulty,
  }) {
    final isSelected = _selectedDifficulty == difficulty;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onDifficultyChanged(difficulty),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF9EE) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(color: const Color(0xFFE5CE9F), width: 2)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            style: AppTextStyles.numberTile.copyWith(
              fontSize: 13,
              color: isSelected
                  ? const Color(0xFF8A5A2B)
                  : const Color(0xFFA6855B),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(LabyrinthLevel level, bool isUnlocked, int stars) {
    return BouncyButton(
      onPressed: isUnlocked
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LabyrinthGameScreen(level: level),
                ),
              ).then((_) => _loadProgress());
            }
          : null,
      backgroundColor: isUnlocked ? const Color(0xFFFFF7E8) : const Color(0xFFE9ECEF),
      shadowColor: isUnlocked ? const Color(0xFFDFC497) : const Color(0xFFCED4DA),
      height: 90,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isUnlocked ? const Color(0xFFE8D0A5) : const Color(0xFFDEE2E6),
            width: 2.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isUnlocked) ...[
              Text(
                '${level.levelNumber}',
                style: AppTextStyles.numberTile.copyWith(
                  fontSize: 26,
                  color: const Color(0xFF8A5A2B),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Text(
                    i < stars ? '⭐' : '☆',
                    style: TextStyle(
                      fontSize: 14,
                      color: i < stars ? const Color(0xFFFFD43B) : Colors.grey,
                    ),
                  );
                }),
              ),
            ] else ...[
              const Icon(Icons.lock_rounded, size: 28, color: Color(0xFFADB5BD)),
              const SizedBox(height: 4),
              Text(
                '${level.levelNumber}',
                style: AppTextStyles.numberTile.copyWith(
                  fontSize: 18,
                  color: const Color(0xFFADB5BD),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
