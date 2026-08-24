import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/bouncy_button.dart';
import '../../domain/game_info.dart';

class GameTileCard extends StatelessWidget {
  final GameInfo game;
  final VoidCallback onPlay;

  const GameTileCard({
    super.key,
    required this.game,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context).strings;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: AppColors.woodBorder.withAlpha(150),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Illustrated Banner Area
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(29)),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      game.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient vignette at bottom of image
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.backgroundCard.withAlpha(80),
                            AppColors.backgroundCard,
                          ],
                          stops: const [0.6, 0.88, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Top Corner Tag
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.pastelPeach,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.pastelPeachDark, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowWarm,
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🧩', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            'Featured Game',
                            style: AppTextStyles.badge.copyWith(
                              color: AppColors.textWhite,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Body Information
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    game.getTitle(context),
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Subtitle / Description
                  Text(
                    game.getSubtitle(context),
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 18),

                  // Badges (Grades 1-2, 3 Lives, Tactile Wood)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildBadge(
                        icon: '🎓',
                        label: l10n.badgeGrades,
                        bgColor: AppColors.pastelYellow.withAlpha(140),
                        borderColor: AppColors.pastelYellowDark.withAlpha(160),
                      ),
                      _buildBadge(
                        icon: '❤️',
                        label: l10n.badgeLives,
                        bgColor: AppColors.pastelRose.withAlpha(140),
                        borderColor: AppColors.pastelRoseDark.withAlpha(160),
                      ),
                      _buildBadge(
                        icon: '🪵',
                        label: l10n.badgeWood,
                        bgColor: AppColors.pastelSage.withAlpha(140),
                        borderColor: AppColors.pastelSageDark.withAlpha(160),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Big Play Button
                  SizedBox(
                    width: double.infinity,
                    child: BouncyButton(
                      height: 64,
                      backgroundColor: AppColors.pastelPeach,
                      shadowColor: AppColors.pastelPeachDark,
                      borderRadius: BorderRadius.circular(22),
                      bevelHeight: 6,
                      onPressed: onPlay,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_arrow_rounded,
                            color: AppColors.textWhite,
                            size: 32,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            l10n.playButton,
                            style: AppTextStyles.buttonLarge.copyWith(fontSize: 21),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String icon,
    required String label,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.badge,
          ),
        ],
      ),
    );
  }
}
