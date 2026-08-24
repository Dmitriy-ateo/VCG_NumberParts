import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/models/card_node.dart';

class WoodenCardWidget extends StatelessWidget {
  final CardNode card;
  final bool showDots;
  final VoidCallback onTap;

  const WoodenCardWidget({
    super.key,
    required this.card,
    this.showDots = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (card.isMatched) {
      return const SizedBox.shrink();
    }

    final isBlocked = card.isBlocked;
    final isSelected = card.isSelected;
    final isHinted = card.isHinted;

    // Layer-based depth styling
    final layerElevation = (card.layer + 1) * 3.0;

    return GestureDetector(
      onTap: isBlocked ? null : onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.06 : (isHinted ? 1.04 : 1.0),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isBlocked
                  ? const [
                      Color(0xFFD6BEA4),
                      Color(0xFFC2A98E),
                    ]
                  : isSelected
                      ? const [
                          Color(0xFFFFF3DB),
                          Color(0xFFFFD48F),
                        ]
                      : const [
                          Color(0xFFF3DEBE),
                          Color(0xFFDEBC92),
                          Color(0xFFCEAA7D),
                        ],
              stops: isBlocked || isSelected ? null : const [0.0, 0.6, 1.0],
            ),
            border: Border.all(
              color: isSelected
                  ? AppColors.pastelPeachDark
                  : isHinted
                      ? AppColors.pastelYellowDark
                      : isBlocked
                          ? AppColors.woodDark.withAlpha(50)
                          : AppColors.woodDark.withAlpha(120),
              width: isSelected || isHinted ? 3.0 : 2.0,
            ),
            boxShadow: isBlocked
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      offset: const Offset(0, 2),
                      blurRadius: 3,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.shadowWarmStrong,
                      offset: Offset(0, layerElevation + (isSelected ? 6 : 2)),
                      blurRadius: isSelected ? 14 : 6,
                    ),
                    if (isSelected)
                      BoxShadow(
                        color: AppColors.pastelPeach.withAlpha(140),
                        offset: Offset.zero,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                  ],
          ),
          child: Stack(
            children: [
              // Subtle inner wood grain highlight bevel
              Positioned(
                top: 2,
                left: 4,
                right: 4,
                height: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(isBlocked ? 20 : 70),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              // Card Content (Number & Subitizing Dots)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${card.value}',
                      style: AppTextStyles.numberTile.copyWith(
                        fontSize: 32,
                        color: isBlocked
                            ? AppColors.textMuted
                            : isSelected
                                ? AppColors.pastelPeachDark
                                : AppColors.textPrimary,
                        shadows: isBlocked
                            ? []
                            : [
                                Shadow(
                                  color: Colors.white.withAlpha(180),
                                  offset: const Offset(0, 1),
                                  blurRadius: 1,
                                ),
                              ],
                      ),
                    ),
                    if (showDots && card.value <= 10) ...[
                      const SizedBox(height: 2),
                      _buildDots(card.value, isBlocked),
                    ],
                  ],
                ),
              ),

              // Blocked Overlay Lock Icon
              if (isBlocked)
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      size: 13,
                      color: Color(0xFF8C735E),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDots(int count, bool isBlocked) {
    return Wrap(
      spacing: 3,
      runSpacing: 2,
      alignment: WrapAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: isBlocked
                ? AppColors.textMuted.withAlpha(100)
                : AppColors.woodDark.withAlpha(180),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
