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
          // 1. Stacked Under-Layers (Chunky Wooden Slab Steps)
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
                        Color.lerp(const Color(0xFFC4864B), const Color(0xFF7A431A), (i + 1) * 0.28)!,
                        Color.lerp(const Color(0xFF935824), const Color(0xFF4A250B), (i + 1) * 0.28)!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
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

          // 2. Main Top Wooden Block
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
                      // 3D Bottom Wood Extrusion Thickness
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF6B3A16),
                                Color(0xFF4A250B),
                                Color(0xFF2E1505),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(isBlocked ? 40 : 110),
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
                        margin: const EdgeInsets.only(bottom: 5.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: const Alignment(-0.85, -0.9),
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
                                                Color(0xFFFBE6CA),
                                                Color(0xFFE8BA87),
                                                Color(0xFFD29E65),
                                              ]
                                            : const [
                                                Color(0xFFDC9F64), // Warm light honey oak
                                                Color(0xFFC4864B), // Rich teak
                                                Color(0xFFA66932), // Golden walnut
                                                Color(0xFF8F511F), // Bottom shadow bevel
                                              ],
                            stops: isBlocked || isSelected || isClearing || isMismatched
                                ? null
                                : const [0.0, 0.32, 0.68, 1.0],
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
                            width: isClearing || isSelected || isHinted || isMismatched ? 3.0 : 2.4,
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
                            // 1. Top-left rim specular highlight
                            Positioned(
                              top: 2,
                              left: 6,
                              right: 6,
                              height: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withAlpha(isBlocked ? 20 : 130),
                                      Colors.white.withAlpha(isBlocked ? 5 : 45),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),

                            // 2. Subtle organic wood texture
                            Positioned.fill(
                              child: Opacity(
                                opacity: isBlocked ? 0.03 : 0.07,
                                child: CustomPaint(
                                  painter: _NaturalWoodGrainPainter(),
                                ),
                              ),
                            ),

                            // 3. Tile Core Content: Huge 3D Raised Clay Digit + Tactile Clay Beads
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                                child: _buildTileContent(palette, isBlocked, isMismatched, isSelected),
                              ),
                            ),

                            // 4. Stack Pile Indicator Badge (Tactile Mini Wood Tab)
                            if (cardsBelowCount > 0 && !isBlocked)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF5A2E0E),
                                        Color(0xFF3D1D07),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(color: const Color(0xFFDC9F64), width: 1),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black45,
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.layers_rounded,
                                        size: 9,
                                        color: Color(0xFFFFD166),
                                      ),
                                      const SizedBox(width: 2.5),
                                      Text(
                                        '${cardsBelowCount + 1}',
                                        style: const TextStyle(
                                          fontSize: 9.5,
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
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(55),
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

    final digitColor = isBlocked
        ? const Color(0xFF6E5642)
        : (isMismatched ? AppColors.accentCoral : palette.primary);

    final darkShadow = isBlocked
        ? const Color(0xFF4A3728)
        : (isMismatched ? AppColors.accentCoralDark : palette.dark);

    final highlight = isBlocked
        ? const Color(0xFF9E836C)
        : (isMismatched ? const Color(0xFFFFB4A2) : palette.highlight);

    // Large, commanding 3D polymer clay font styling
    final textStyle = GoogleFonts.fredoka(
      fontSize: value >= 10 ? 38 : 46,
      fontWeight: FontWeight.w700,
      color: digitColor,
      height: 1.0,
      letterSpacing: -1.0,
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
                offset: const Offset(1.5, 2.8),
                blurRadius: 0.8,
              ),
              // Ambient wood crevice shadow
              Shadow(
                color: Colors.black.withAlpha(130),
                offset: const Offset(0.0, 2.5),
                blurRadius: 4.0,
              ),
              // Top-left specular clay highlight
              Shadow(
                color: highlight.withAlpha(230),
                offset: const Offset(-1.0, -1.0),
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

    // Exact replica of index banner patterns:
    // 10: Two rows of 5 beads along the bottom
    // 7: 3 beads on left, 4 on right (2x2 grid)
    // 3: 1 bead on left, 2 on right (top-right & bottom-right)
    if (value == 10) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 1),
          Text(
            '$value',
            style: textStyle.copyWith(fontSize: 36),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: _buildClayBead(palette, isBlocked, isMismatched, size: 7.2),
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
                child: _buildClayBead(palette, isBlocked, isMismatched, size: 7.2),
              ),
            ),
          ),
        ],
      );
    } else if (value == 3) {
      // Tile 3 exact replica: 1 bead on left, 2 beads on right (top-right & bottom-right)
      return Stack(
        children: [
          Center(
            child: Text(
              '$value',
              style: textStyle,
            ),
          ),
          // Left bead (centered vertically)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: _buildClayBead(palette, isBlocked, isMismatched, size: 8.5),
            ),
          ),
          // Top-right bead
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 6),
              child: _buildClayBead(palette, isBlocked, isMismatched, size: 8.5),
            ),
          ),
          // Bottom-right bead
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 6),
              child: _buildClayBead(palette, isBlocked, isMismatched, size: 8.5),
            ),
          ),
        ],
      );
    } else if (value == 7) {
      // Tile 7 exact replica: 3 beads on left column, 4 beads on right (2x2 grid)
      return Stack(
        children: [
          Center(
            child: Text(
              '$value',
              style: textStyle,
            ),
          ),
          // Left column: 3 beads
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
                  (i) => _buildClayBead(palette, isBlocked, isMismatched, size: 8.0),
                ),
              ),
            ),
          ),
          // Right column: 4 beads in 2x2 cluster
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildClayBead(palette, isBlocked, isMismatched, size: 7.2),
                      const SizedBox(width: 2.5),
                      _buildClayBead(palette, isBlocked, isMismatched, size: 7.2),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildClayBead(palette, isBlocked, isMismatched, size: 7.2),
                      const SizedBox(width: 2.5),
                      _buildClayBead(palette, isBlocked, isMismatched, size: 7.2),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (value == 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$value',
            style: textStyle,
          ),
          const SizedBox(height: 2),
          _buildClayBead(palette, isBlocked, isMismatched, size: 9.0),
        ],
      );
    } else if (value == 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$value',
            style: textStyle,
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildClayBead(palette, isBlocked, isMismatched, size: 8.5),
              const SizedBox(width: 6),
              _buildClayBead(palette, isBlocked, isMismatched, size: 8.5),
            ],
          ),
        ],
      );
    } else if (value >= 4 && value <= 9) {
      final leftCount = value ~/ 2;
      final rightCount = value - leftCount;

      return Stack(
        children: [
          Center(
            child: Text(
              '$value',
              style: textStyle,
            ),
          ),
          if (leftCount > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    leftCount,
                    (i) => _buildClayBead(palette, isBlocked, isMismatched, size: 8.0),
                  ),
                ),
              ),
            ),
          if (rightCount > 0)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    rightCount,
                    (i) => _buildClayBead(palette, isBlocked, isMismatched, size: 8.0),
                  ),
                ),
              ),
            ),
        ],
      );
    } else {
      // Numbers > 10
      return Center(
        child: Text(
          '$value',
          style: textStyle.copyWith(fontSize: 34),
        ),
      );
    }
  }

  /// Builds a single 3D glossy molded polymer clay bead sphere
  Widget _buildClayBead(
    ClayPalette palette,
    bool isBlocked,
    bool isMismatched, {
    double size = 8.5,
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
            offset: const Offset(0.5, 1.5),
            blurRadius: 1.5,
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

/// Custom painter for subtle organic natural wood grain
class _NaturalWoodGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A2508)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.28);
    path.quadraticBezierTo(size.width * 0.45, size.height * 0.24, size.width, size.height * 0.30);

    path.moveTo(0, size.height * 0.58);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.62, size.width, size.height * 0.55);

    path.moveTo(0, size.height * 0.84);
    path.quadraticBezierTo(size.width * 0.48, size.height * 0.81, size.width, size.height * 0.86);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
