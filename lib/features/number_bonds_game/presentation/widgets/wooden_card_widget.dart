import 'dart:math' as math;
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
    final isClearing = card.isClearing;
    final isMismatched = card.isMismatched;

    return GestureDetector(
      onTap: isBlocked || isClearing || isMismatched ? null : onTap,
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

          // 2. Main Top Wooden Card with Shake, Removal & Pop Animations
          TweenAnimationBuilder<double>(
            key: ValueKey('shake_${card.id}_$isMismatched'),
            tween: Tween<double>(begin: 0.0, end: isMismatched ? 1.0 : 0.0),
            duration: const Duration(milliseconds: 380),
            builder: (context, animValue, childWidget) {
              final shakeOffset = isMismatched
                  ? math.sin(animValue * math.pi * 4.0) * (1.0 - animValue) * 8.0
                  : 0.0;
              final shakeRotation = isMismatched
                  ? math.sin(animValue * math.pi * 4.0) * (1.0 - animValue) * 0.04
                  : 0.0;

              return Transform.translate(
                offset: Offset(shakeOffset, 0),
                child: Transform.rotate(
                  angle: shakeRotation,
                  child: childWidget,
                ),
              );
            },
            child: AnimatedScale(
              scale: isClearing
                  ? 1.18
                  : (isMismatched
                      ? 1.05
                      : (isSelected ? 1.06 : (isHinted ? 1.04 : 1.0))),
              duration: Duration(milliseconds: isClearing ? 280 : 150),
              curve: isClearing ? Curves.easeOutCubic : Curves.easeOutBack,
              child: AnimatedOpacity(
                opacity: isClearing ? 0.0 : 1.0,
                duration: Duration(milliseconds: isClearing ? 280 : 150),
                curve: Curves.easeInQuad,
                child: AnimatedRotation(
                  turns: isClearing ? 0.04 : 0.0,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isClearing
                            ? const [
                                Color(0xFFFFF9E6),
                                Color(0xFFFFDF88),
                              ]
                            : isMismatched
                                ? const [
                                    Color(0xFFFFEBEB),
                                    Color(0xFFFFB8B8),
                                  ]
                                : isBlocked
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
                        stops: isBlocked || isSelected || isClearing || isMismatched
                            ? null
                            : const [0.0, 0.6, 1.0],
                      ),
                      border: Border.all(
                        color: isClearing
                            ? AppColors.pastelYellowDark
                            : isMismatched
                                ? AppColors.accentCoral
                                : isSelected
                                    ? AppColors.pastelPeachDark
                                    : isHinted
                                        ? AppColors.pastelYellowDark
                                        : isBlocked
                                            ? AppColors.woodDark.withAlpha(50)
                                            : AppColors.woodDark.withAlpha(140),
                        width: isClearing || isSelected || isHinted || isMismatched ? 3.0 : 2.2,
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
                                color: isMismatched
                                    ? AppColors.accentCoral.withAlpha(140)
                                    : AppColors.shadowWarmStrong,
                                offset: Offset(
                                  0,
                                  (isSelected || isClearing || isMismatched ? 10.0 : 4.0) +
                                      cardsBelowCount * 1.5,
                                ),
                                blurRadius: isClearing
                                    ? 20.0
                                    : (isMismatched ? 14.0 : (isSelected ? 16.0 : 8.0)),
                              ),
                              if (isSelected || isClearing || isMismatched)
                                BoxShadow(
                                  color: (isClearing
                                          ? AppColors.pastelYellow
                                          : (isMismatched
                                              ? AppColors.accentCoral
                                              : AppColors.pastelPeach))
                                      .withAlpha(160),
                                  offset: Offset.zero,
                                  blurRadius: isClearing || isMismatched ? 16 : 12,
                                  spreadRadius: isClearing ? 4.0 : 2.5,
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
                                      : isMismatched
                                          ? AppColors.accentCoral
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
                                _buildDots(card.value, isBlocked, isMismatched),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots(int count, bool isBlocked, bool isMismatched) {
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
                : isMismatched
                    ? AppColors.accentCoral.withAlpha(200)
                    : AppColors.woodDark.withAlpha(180),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
