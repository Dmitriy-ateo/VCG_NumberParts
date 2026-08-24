import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/models/card_node.dart';

class ClayPalette {
  final Color primary;
  final Color dark;
  final Color highlight;

  const ClayPalette({
    required this.primary,
    required this.dark,
    required this.highlight,
  });
}

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

  static const Map<int, ClayPalette> _clayPalettes = {
    1: ClayPalette(
      primary: Color(0xFFEE6055),
      dark: Color(0xFFB83228),
      highlight: Color(0xFFFF9B92),
    ),
    2: ClayPalette(
      primary: Color(0xFFF4A261),
      dark: Color(0xFFC77126),
      highlight: Color(0xFFFFCA9B),
    ),
    3: ClayPalette(
      primary: Color(0xFFF26419),
      dark: Color(0xFFB54105),
      highlight: Color(0xFFFF9259),
    ),
    4: ClayPalette(
      primary: Color(0xFF9B5DE5),
      dark: Color(0xFF6B2FB8),
      highlight: Color(0xFFC99DF6),
    ),
    5: ClayPalette(
      primary: Color(0xFFE63946),
      dark: Color(0xFFA81824),
      highlight: Color(0xFFFF7A86),
    ),
    6: ClayPalette(
      primary: Color(0xFF2A9D8F),
      dark: Color(0xFF16685E),
      highlight: Color(0xFF62CEC0),
    ),
    7: ClayPalette(
      primary: Color(0xFF00A896),
      dark: Color(0xFF00665B),
      highlight: Color(0xFF42DEC9),
    ),
    8: ClayPalette(
      primary: Color(0xFF2575FC),
      dark: Color(0xFF0D47A1),
      highlight: Color(0xFF75A6FF),
    ),
    9: ClayPalette(
      primary: Color(0xFF8338EC),
      dark: Color(0xFF5616AE),
      highlight: Color(0xFFB37FFF),
    ),
    10: ClayPalette(
      primary: Color(0xFFE9B949),
      dark: Color(0xFFB88517),
      highlight: Color(0xFFFFDB82),
    ),
  };

  ClayPalette _getPalette(int value) {
    if (_clayPalettes.containsKey(value)) {
      return _clayPalettes[value]!;
    }
    // Fallback for numbers > 10
    final mod = ((value - 1) % 10) + 1;
    return _clayPalettes[mod] ??
        const ClayPalette(
          primary: Color(0xFFE9B949),
          dark: Color(0xFFB88517),
          highlight: Color(0xFFFFDB82),
        );
  }

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
    final palette = _getPalette(card.value);

    return GestureDetector(
      onTap: isBlocked || isClearing || isMismatched ? null : onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Stacked Under-Layers (Stepped Chunky Wooden Blocks)
          if (cardsBelowCount > 0 && !isBlocked)
            ...List.generate(cardsBelowCount.clamp(1, 3), (i) {
              final step = (i + 1) * 3.5;
              return Positioned(
                left: step * 0.7,
                right: -step * 0.7,
                top: step,
                bottom: -step,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.lerp(const Color(0xFFBA804A), const Color(0xFF6B3A16), (i + 1) * 0.3)!,
                        Color.lerp(const Color(0xFF8B5120), const Color(0xFF4A250B), (i + 1) * 0.3)!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF4A250B),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(90),
                        offset: Offset(0, 3.0 + i * 2.0),
                        blurRadius: 4.0 + i * 2.0,
                      ),
                    ],
                  ),
                ),
              );
            }),

          // 2. Main Top Wooden Block with Realistic Bevels & Inlaid Clay Styling
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
                  child: Stack(
                    children: [
                      // 3D Bottom Wood Block Edge (Thickness / Extrusion)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF6B3A16),
                                Color(0xFF4A250B),
                                Color(0xFF331705),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(isBlocked ? 45 : 120),
                                offset: Offset(0, isSelected ? 8.0 : 5.0),
                                blurRadius: isSelected ? 12.0 : 7.0,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Main Top Face of the Solid Wooden Block
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(bottom: 4.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: const Alignment(-0.8, -0.9),
                            end: const Alignment(0.9, 1.0),
                            colors: isClearing
                                ? const [
                                    Color(0xFFFFF9E6),
                                    Color(0xFFFFE599),
                                    Color(0xFFFFD166),
                                  ]
                                : isMismatched
                                    ? const [
                                        Color(0xFFFFE0D6),
                                        Color(0xFFF79D84),
                                        Color(0xFFE76F51),
                                      ]
                                    : isBlocked
                                        ? const [
                                            Color(0xFFB59374),
                                            Color(0xFF9E7E62),
                                            Color(0xFF82644B),
                                          ]
                                        : isSelected
                                            ? const [
                                                Color(0xFFFBE4C8),
                                                Color(0xFFE5B584),
                                                Color(0xFFCF9860),
                                              ]
                                            : const [
                                                Color(0xFFD49F6A), // Highlight top-left
                                                Color(0xFFC08750), // Main warm teak
                                                Color(0xFFA66E38), // Golden walnut
                                                Color(0xFF8A5322), // Deep shadow edge
                                              ],
                            stops: isBlocked || isSelected || isClearing || isMismatched
                                ? null
                                : const [0.0, 0.35, 0.72, 1.0],
                          ),
                          border: Border.all(
                            color: isClearing
                                ? AppColors.pastelYellowDark
                                : isMismatched
                                    ? AppColors.accentCoral
                                    : isSelected
                                        ? const Color(0xFFFFE0A3)
                                        : isHinted
                                            ? const Color(0xFFFFD166)
                                            : isBlocked
                                                ? const Color(0xFF6B513C)
                                                : const Color(0xFF5A2E0E),
                            width: isClearing || isSelected || isHinted || isMismatched ? 3.0 : 2.2,
                          ),
                          boxShadow: [
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
                            // 1. Top-left rim specular bevel highlight
                            Positioned(
                              top: 2,
                              left: 6,
                              right: 6,
                              height: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withAlpha(isBlocked ? 20 : 120),
                                      Colors.white.withAlpha(isBlocked ? 5 : 40),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),

                            // 2. Subtle wood grain horizontal lines
                            Positioned.fill(
                              child: Opacity(
                                opacity: isBlocked ? 0.04 : 0.09,
                                child: CustomPaint(
                                  painter: _WoodGrainPainter(),
                                ),
                              ),
                            ),

                            // 3. Tile Core Content: 3D Inlaid Clay Number & Surrounding Clay Beads
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                                child: _buildTileContent(palette, isBlocked, isMismatched, isSelected),
                              ),
                            ),

                            // 4. Stack Pile Indicator Badge (e.g. "🥞 2")
                            if (cardsBelowCount > 0 && !isBlocked)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF5A2E0E),
                                        Color(0xFF3D1D07),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFFD49F6A), width: 1),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black38,
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
                                        style: TextStyle(fontSize: 8),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${cardsBelowCount + 1}',
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            // 5. Blocked Overlay Lock Icon
                            if (isBlocked)
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(2.5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(50),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lock_rounded,
                                    size: 11,
                                    color: Color(0xFF6B513C),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the 3D Inlaid Clay Digit + Layout-Aware Clay Beads
  Widget _buildTileContent(
    ClayPalette palette,
    bool isBlocked,
    bool isMismatched,
    bool isSelected,
  ) {
    final value = card.value;

    // Number text style with 3D polymer-clay raised inlay effect
    final digitColor = isBlocked
        ? const Color(0xFF6E5642)
        : (isMismatched ? AppColors.accentCoral : palette.primary);

    final darkShadow = isBlocked
        ? const Color(0xFF4A3728)
        : (isMismatched ? AppColors.accentCoralDark : palette.dark);

    final highlight = isBlocked
        ? const Color(0xFF9E836C)
        : (isMismatched ? const Color(0xFFFFB4A2) : palette.highlight);

    final textStyle = GoogleFonts.fredoka(
      fontSize: value >= 10 ? 30 : 36,
      fontWeight: FontWeight.w700,
      color: digitColor,
      height: 1.0,
      shadows: isBlocked
          ? [
              const Shadow(
                color: Color(0x903D2A1C),
                offset: Offset(1.0, 1.5),
                blurRadius: 0.5,
              ),
            ]
          : [
              // Bottom dark extrusion / bevel
              Shadow(
                color: darkShadow,
                offset: const Offset(1.2, 2.2),
                blurRadius: 0.8,
              ),
              // Ambient wood crevice shadow
              Shadow(
                color: Colors.black.withAlpha(120),
                offset: const Offset(0.0, 2.0),
                blurRadius: 3.5,
              ),
              // Top-left specular clay highlight
              Shadow(
                color: highlight.withAlpha(220),
                offset: const Offset(-0.8, -0.8),
                blurRadius: 0.5,
              ),
            ],
    );

    if (!showDots) {
      return Center(
        child: Text(
          '$value',
          style: textStyle,
        ),
      );
    }

    // Arrangement modeled after index page tiles:
    // 10: 2 rows of 5 beads along the bottom
    // 7: 3 beads on left, 4 on right
    // 3: 1 bead on left, 2 on right
    // 6, 8, 9: side columns
    // 1, 2: bottom row or sides
    if (value == 10) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 2),
          Text(
            '$value',
            style: textStyle,
          ),
          const SizedBox(height: 4),
          // Two rows of 5 beads along the bottom (exact match to index tile 10)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: _buildClayBead(palette, isBlocked, isMismatched, size: 6.8),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: _buildClayBead(palette, isBlocked, isMismatched, size: 6.8),
              ),
            ),
          ),
        ],
      );
    } else if (value >= 3 && value <= 9) {
      // Side dots arrangement (e.g. 7 = 3 left, 4 right; 3 = 1 left, 2 right)
      final leftCount = value ~/ 2;
      final rightCount = value - leftCount;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Beads Column
          if (leftCount > 0)
            SizedBox(
              width: 14,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  leftCount,
                  (i) => _buildClayBead(palette, isBlocked, isMismatched, size: 7.2),
                ),
              ),
            ),

          // Central Raised Clay Digit
          Expanded(
            child: Center(
              child: Text(
                '$value',
                style: textStyle,
              ),
            ),
          ),

          // Right Beads Column
          if (rightCount > 0)
            SizedBox(
              width: 14,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  rightCount,
                  (i) => _buildClayBead(palette, isBlocked, isMismatched, size: 7.2),
                ),
              ),
            ),
        ],
      );
    } else {
      // Small values (1, 2) or values > 10
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$value',
            style: textStyle,
          ),
          if (value <= 2) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                value,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: _buildClayBead(palette, isBlocked, isMismatched, size: 7.5),
                ),
              ),
            ),
          ],
        ],
      );
    }
  }

  /// Builds a single 3D glossy molded clay bead sphere
  Widget _buildClayBead(
    ClayPalette palette,
    bool isBlocked,
    bool isMismatched, {
    double size = 7.5,
  }) {
    final primary = isBlocked
        ? const Color(0xFF6E5642)
        : (isMismatched ? AppColors.accentCoral : palette.primary);

    final dark = isBlocked
        ? const Color(0xFF4A3728)
        : (isMismatched ? AppColors.accentCoralDark : palette.dark);

    final highlight = isBlocked
        ? const Color(0xFF9E836C)
        : (isMismatched ? const Color(0xFFFFB4A2) : palette.highlight);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.35, -0.35),
          radius: 0.8,
          colors: [
            highlight,
            primary,
            dark,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isBlocked ? 40 : 100),
            offset: const Offset(0.5, 1.2),
            blurRadius: 1.2,
          ),
          BoxShadow(
            color: Colors.black.withAlpha(isBlocked ? 20 : 60),
            offset: const Offset(0, 0.5),
            blurRadius: 0.5,
          ),
        ],
      ),
    );
  }
}

/// Custom painter for subtle organic wood grain striations
class _WoodGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Soft subtle wood curved rings
    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.22, size.width, size.height * 0.28);

    path.moveTo(0, size.height * 0.55);
    path.quadraticBezierTo(size.width * 0.45, size.height * 0.58, size.width, size.height * 0.52);

    path.moveTo(0, size.height * 0.82);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.79, size.width, size.height * 0.85);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
