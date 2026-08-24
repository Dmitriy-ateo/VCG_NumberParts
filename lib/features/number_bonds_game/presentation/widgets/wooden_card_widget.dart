import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/models/card_node.dart';

class WoodenCardWidget extends StatelessWidget {
  final CardNode card;
  final bool showDots;
  final int cardsBelowCount;
  final VoidCallback onTap;

  const WoodenCardWidget({
    super.key,
    required this.card,
    this.showDots = true,
    this.cardsBelowCount = 0,
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

    return GestureDetector(
      onTap: isBlocked ? null : onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Stacked Under-Layers (Stepped Wooden Pile Effect)
          if (cardsBelowCount > 0 && !isBlocked)
            ...List.generate(cardsBelowCount.clamp(1, 3), (i) {
              final step = (i + 1) * 3.5;
              return Positioned(
                left: step * 0.8,
                right: -step * 0.8,
                top: step,
                bottom: -step,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.lerp(
                      const Color(0xFFCDB08E),
                      const Color(0xFF9E7C5C),
                      (i + 1) * 0.25,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.woodDark.withAlpha(90),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowWarmStrong,
                        offset: Offset(0, 3.0 + i * 2.0),
                        blurRadius: 4.0 + i * 2.0,
                      ),
                    ],
                  ),
                ),
              );
            }),

          // 2. Main Top Wooden Card
          AnimatedScale(
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
                              Color(0xFFF6E4CA),
                              Color(0xFFE4C39B),
                              Color(0xFFD5AF82),
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
                              : AppColors.woodDark.withAlpha(140),
                  width: isSelected || isHinted ? 3.0 : 2.2,
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
                          offset: Offset(0, (isSelected ? 10.0 : 4.0) + cardsBelowCount * 1.5),
                          blurRadius: isSelected ? 16.0 : 8.0,
                        ),
                        if (isSelected)
                          BoxShadow(
                            color: AppColors.pastelPeach.withAlpha(150),
                            offset: Offset.zero,
                            blurRadius: 12,
                            spreadRadius: 2.5,
                          ),
                      ],
              ),
              child: Stack(
                children: [
                  // Subtle top bevel highlight
                  Positioned(
                    top: 2,
                    left: 4,
                    right: 4,
                    height: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(isBlocked ? 20 : 85),
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
                            fontSize: 34,
                            color: isBlocked
                                ? AppColors.textMuted
                                : isSelected
                                    ? AppColors.pastelPeachDark
                                    : AppColors.textPrimary,
                            shadows: isBlocked
                                ? []
                                : [
                                    Shadow(
                                      color: Colors.white.withAlpha(190),
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

                  // Stack Pile Indicator Badge (e.g. "x2", "x3")
                  if (cardsBelowCount > 0 && !isBlocked)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.woodDark.withAlpha(190),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.woodHoney, width: 1),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '🥞',
                              style: TextStyle(fontSize: 9),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${cardsBelowCount + 1}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textWhite,
                              ),
                            ),
                          ],
                        ),
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
        ],
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
