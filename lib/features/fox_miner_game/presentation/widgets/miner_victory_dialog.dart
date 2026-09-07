import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/bouncy_button.dart';
import '../../domain/models/miner_level_data.dart';

class MinerVictoryDialog extends StatelessWidget {
  final MinerLevelData level;
  final int stars;
  final int totalSwings;
  final int missedSwings;
  final VoidCallback onNextLevel;
  final VoidCallback onReplay;
  final VoidCallback onMenu;

  const MinerVictoryDialog({
    super.key,
    required this.level,
    required this.stars,
    required this.totalSwings,
    required this.missedSwings,
    required this.onNextLevel,
    required this.onReplay,
    required this.onMenu,
  });

  static Future<void> show(
    BuildContext context, {
    required MinerLevelData level,
    required int stars,
    required int totalSwings,
    required int missedSwings,
    required VoidCallback onNextLevel,
    required VoidCallback onReplay,
    required VoidCallback onMenu,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => MinerVictoryDialog(
        level: level,
        stars: stars,
        totalSwings: totalSwings,
        missedSwings: missedSwings,
        onNextLevel: onNextLevel,
        onReplay: onReplay,
        onMenu: onMenu,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final strings = l10n.strings;

    final target = level.targetNumber;
    final tens = level.tensValue;
    final ones = level.singlesCount;

    String praiseTitle = strings.perfectMining;
    if (stars == 2) praiseTitle = strings.greatMining;
    if (stars == 1) praiseTitle = strings.goodEffortMining;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stars Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final isEarned = index < stars;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    isEarned ? '⭐' : '☆',
                    style: TextStyle(
                      fontSize: 40,
                      color: isEarned ? const Color(0xFFFAB005) : Colors.grey.shade400,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 12),

            // Praise Title
            Text(
              praiseTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: 22,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Place Value Math Synthesis Formula: 42 = 40 + 2
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE5CE9F),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$target',
                    style: AppTextStyles.numberTile.copyWith(
                      fontSize: 28,
                      color: Colors.deepPurple,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '=',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 24,
                        color: const Color(0xFF8A5A2B),
                      ),
                    ),
                  ),
                  Text(
                    '$tens',
                    style: AppTextStyles.numberTile.copyWith(
                      fontSize: 28,
                      color: const Color(0xFFD9480F),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '+',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 24,
                        color: const Color(0xFF8A5A2B),
                      ),
                    ),
                  ),
                  Text(
                    '$ones',
                    style: AppTextStyles.numberTile.copyWith(
                      fontSize: 28,
                      color: const Color(0xFF0CA678),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Performance stats: Swings and Misses
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatBadge(
                  icon: '⛏️',
                  label: strings.swingsLabel,
                  value: '$totalSwings / ${level.optimalSwings}',
                  color: AppColors.pastelPeach,
                ),
                const SizedBox(width: 12),
                _buildStatBadge(
                  icon: missedSwings == 0 ? '✨' : '⚠️',
                  label: strings.missesLabel,
                  value: '$missedSwings',
                  color: missedSwings == 0 ? AppColors.pastelSage : AppColors.pastelRose,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action Buttons: Next Level, Replay, Menu
            Row(
              children: [
                // Replay
                Expanded(
                  child: BouncyButton(
                    onPressed: onReplay,
                    backgroundColor: const Color(0xFFFFD8A8),
                    shadowColor: const Color(0xFFE8590C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: Text(
                        strings.replayButton,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD9480F),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Next Level
                Expanded(
                  flex: 2,
                  child: BouncyButton(
                    onPressed: onNextLevel,
                    backgroundColor: const Color(0xFF69DB7C),
                    shadowColor: const Color(0xFF2B8A3E),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: Text(
                        strings.nextLevelButton,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Menu button
            TextButton(
              onPressed: onMenu,
              child: Text(
                strings.homeButton,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge({
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
