import 'package:flutter/material.dart';
import 'package:number_parts/app/theme/app_colors.dart';
import 'package:number_parts/app/theme/app_text_styles.dart';
import 'package:number_parts/core/l10n/app_localizations.dart';
import 'package:number_parts/core/storage/progress_repository.dart';
import 'package:number_parts/core/widgets/bouncy_button.dart';
import 'package:number_parts/features/trampoline_game/domain/models/fox_animation_state.dart';
import 'package:number_parts/features/trampoline_game/domain/models/trampoline_difficulty.dart';
import 'package:number_parts/features/trampoline_game/presentation/trampoline_game_screen.dart';
import 'package:number_parts/features/trampoline_game/presentation/widgets/animated_fox_character.dart';

class TrampolineMenuScreen extends StatefulWidget {
  const TrampolineMenuScreen({super.key});

  @override
  State<TrampolineMenuScreen> createState() => _TrampolineMenuScreenState();
}

class _TrampolineMenuScreenState extends State<TrampolineMenuScreen> {
  TrampolineDifficulty _selectedDifficulty = TrampolineDifficulty.simple;
  final ProgressRepository _progressRepository = ProgressRepository();
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final score = await _progressRepository.getTrampolineHighScore(_selectedDifficulty.name);
    if (mounted) {
      setState(() {
        _highScore = score;
      });
    }
  }

  void _onDifficultyChanged(TrampolineDifficulty diff) {
    if (_selectedDifficulty == diff) return;
    setState(() {
      _selectedDifficulty = diff;
    });
    _loadHighScore();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP BAR ──────────────────────────────────────────────
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
                    l10n.strings.gameTrampolineTitle,
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── ANIMATED MASCOT FOX HERO ─────────────────────────────
            const AnimatedFoxCharacter(
              state: FoxAnimationState.idle,
              width: 140,
              height: 170,
            ),
            const SizedBox(height: 16),

            Text(
              l10n.strings.gameTrampolineTitle,
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 28,
                color: const Color(0xFF8A5A2B),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l10n.strings.gameTrampolineSubtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFFA67B48),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(),

            // ── DIFFICULTY TABS ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      difficulty: TrampolineDifficulty.simple,
                    ),
                    _buildTabButton(
                      title: l10n.strings.tabAdvanced,
                      difficulty: TrampolineDifficulty.advanced,
                    ),
                    _buildTabButton(
                      title: l10n.strings.tabHard,
                      difficulty: TrampolineDifficulty.hard,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── HIGH SCORE BADGE ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5CE9F), width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    '${l10n.strings.bestScoreLabel}: $_highScore',
                    style: AppTextStyles.numberTile.copyWith(
                      fontSize: 18,
                      color: const Color(0xFF8A5A2B),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── PLAY BUTTON ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: BouncyButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TrampolineGameScreen(
                        difficulty: _selectedDifficulty,
                      ),
                    ),
                  ).then((_) => _loadHighScore());
                },
                backgroundColor: AppColors.pastelSage,
                shadowColor: AppColors.pastelSageDark,
                height: 56,
                child: Center(
                  child: Text(
                    l10n.strings.playButton,
                    style: AppTextStyles.buttonLarge.copyWith(
                      fontSize: 20,
                      color: const Color(0xFF2B5329),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required TrampolineDifficulty difficulty,
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
}
