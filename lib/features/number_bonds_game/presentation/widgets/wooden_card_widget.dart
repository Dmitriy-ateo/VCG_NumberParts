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
      primary: Color(0xFFF25A4B),
      dark: Color(0xFFBE2E22),
      highlight: Color(0xFFFF9B92),
    ),
    2: ClayPalette(
      primary: Color(0xFFF59E42),
      dark: Color(0xFFC76F1E),
      highlight: Color(0xFFFFCC94),
    ),
    3: ClayPalette(
      primary: Color(0xFFF26419),
      dark: Color(0xFFB84405),
      highlight: Color(0xFFFF955C),
    ),
    4: ClayPalette(
      primary: Color(0xFF9D5CE6),
      dark: Color(0xFF6B2FB8),
      highlight: Color(0xFFCC9EFA),
    ),
    5: ClayPalette(
      primary: Color(0xFFE83A4A),
      dark: Color(0xFFA81824),
      highlight: Color(0xFFFF7C88),
    ),
    6: ClayPalette(
      primary: Color(0xFF26A69A),
      dark: Color(0xFF146860),
      highlight: Color(0xFF64D2C5),
    ),
    7: ClayPalette(
      primary: Color(0xFF00A896),
      dark: Color(0xFF00665B),
      highlight: Color(0xFF42DEC9),
    ),
    8: ClayPalette(
      primary: Color(0xFF2979FF),
      dark: Color(0xFF0D47A1),
      highlight: Color(0xFF75A6FF),
    ),
    9: ClayPalette(
      primary: Color(0xFF8338EC),
      dark: Color(0xFF5616AE),
      highlight: Color(0xFFB37FFF),
    ),
    10: ClayPalette(
      primary: Color(0xFFF3B431),
      dark: Color(0xFFB88012),
      highlight: Color(0xFFFFDB7A),
    ),
  };

  ClayPalette _getPalette(int value) {
    if (_clayPalettes.containsKey(value)) {
      return _clayPalettes[value]!;
    }
    final mod = ((value - 1) % 10) + 1;
    return _clayPalettes[mod] ??
        const ClayPalette(
          primary: Color(0xFFF3B431),
          dark: Color(0xFFB88012),
          highlight: Color(0xFFFFDB7A),
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
          // 1. Stacked Under-Layers (Light Honey Wood Steps)
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
                        Color.lerp(const Color(0xFFE4BF94), const Color(0xFFBA8A5A), (i + 1) * 0.28)!,
                        Color.lerp(const Color(0xFFCBA074), const Color(0xFF9E6D40), (i + 1) * 0.28)!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF9E6D40),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x184D3319),
                        offset: Offset(0, 2.0 + i * 1.5),
                        blurRadius: 4.0 + i * 1.5,
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
                      // 3D Bottom Wood Extrusion Thickness (Light warm honey-caramel bevel)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: 5.5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFAD7845),
                                Color(0xFF8F5828),
                                Color(0xFF75431A),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x224D3319),
                                offset: Offset(0, isSelected ? 6.0 : 4.0),
                                blurRadius: isSelected ? 10.0 : 6.0,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Main Top Face of the Solid Wooden Block (Bright, Light Golden Warm Oak)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(bottom: 4.8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: const Alignment(-0.85, -0.9),
                            end: const Alignment(0.9, 1.0),
                            colors: isClearing
                                ? const [
                                    Color(0xFFFFFDF5),
                                    Color(0xFFFFEEB8),
                                    Color(0xFFFFD97D),
                                  ]
                                : isMismatched
                                    ? const [
                                        Color(0xFFFFEFEA),
                                        Color(0xFFFFBCAC),
                                        Color(0xFFF28169),
                                      ]
                                    : isBlocked
                                        ? const [
                                            Color(0xFFD6C0A9),
                                            Color(0xFFC4AB91),
                                            Color(0xFFB0957A),
                                          ]
                                        : isSelected
                                            ? const [
                                                Color(0xFFFFF5E6),
                                                Color(0xFFFFE2BD),
                                                Color(0xFFFFCE94),
                                              ]
                                            : const [
                                                Color(0xFFFBE6C8), // Light radiant golden highlight
                                                Color(0xFFF0CB9E), // Smooth warm honey maple
                                                Color(0xFFE2B784), // Golden teak midtone
                                                Color(0xFFD09F69), // Soft warm edge bevel
                                              ],
                            stops: isBlocked || isSelected || isClearing || isMismatched
                                ? null
                                : const [0.0, 0.30, 0.70, 1.0],
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
                                                ? const Color(0xFF9E846E)
                                                : const Color(0xFF8C5828),
                            width: isClearing || isSelected || isHinted || isMismatched ? 2.8 : 2.0,
                          ),
                          boxShadow: [
                            if (isSelected || isClearing || isMismatched)
                              BoxShadow(
                                color: (isClearing
                                        ? AppColors.pastelYellow
                                        : (isMismatched
                                            ? AppColors.accentCoral
                                            : AppColors.pastelPeach))
                                    .withAlpha(140),
                                offset: Offset.zero,
                                blurRadius: isClearing || isMismatched ? 14 : 10,
                                spreadRadius: isClearing ? 3.5 : 2.0,
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
                                      Colors.white.withAlpha(isBlocked ? 25 : 150),
                                      Colors.white.withAlpha(isBlocked ? 5 : 50),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),

                            // 2. Subtle soft diffuse wood texture
                            Positioned.fill(
                              child: Opacity(
                                opacity: isBlocked ? 0.02 : 0.04,
                                child: CustomPaint(
                                  painter: _SoftWoodGrainPainter(),
                                ),
                              ),
                            ),

                            // 3. Tile Core Content: Huge Bold 3D Inlaid Clay Digit + Tactile Beads
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                child: _buildTileContent(palette, isBlocked, isMismatched, isSelected),
                              ),
                            ),

                            // 4. Stack Pile Indicator Badge (Light Caramel Wood Tab)
                            if (cardsBelowCount > 0 && !isBlocked)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF8F5828),
                                        Color(0xFF75431A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFFFBE6C8), width: 1),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x20000000),
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
                                    color: Colors.black.withAlpha(35),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lock_rounded,
                                    size: 11,
                                    color: Color(0xFF8A6C54),
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
        ? const Color(0xFF8C7561)
        : (isMismatched ? AppColors.accentCoral : palette.primary);

    final darkShadow = isBlocked
        ? const Color(0xFF6B5442)
        : (isMismatched ? AppColors.accentCoralDark : palette.dark);

    final highlight = isBlocked
        ? const Color(0xFFBDB0A2)
        : (isMismatched ? const Color(0xFFFFB4A2) : palette.highlight);

    // Large, prominent 3D polymer clay font styling
    final textStyle = GoogleFonts.fredoka(
      fontSize: value >= 10 ? 44 : 54,
      fontWeight: FontWeight.w700,
      color: digitColor,
      height: 1.0,
      letterSpacing: -1.5,
      shadows: isBlocked
          ? [
              const Shadow(
                color: Color(0x403D2A1C),
                offset: Offset(0.8, 1.2),
                blurRadius: 0.5,
              ),
            ]
          : [
              // Bottom dark extrusion bevel
              Shadow(
                color: darkShadow,
                offset: const Offset(1.2, 2.2),
                blurRadius: 0.5,
              ),
              // Soft warm ambient crevice shadow
              const Shadow(
                color: Color(0x35402005),
                offset: Offset(0.0, 1.8),
                blurRadius: 2.5,
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
            style: textStyle.copyWith(fontSize: 40),
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
      // Tile 3: 1 bead on left, 2 beads on right (top-right & bottom-right)
      return Stack(
        children: [
          Center(
            child: Text(
              '$value',
              style: textStyle,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: _buildClayBead(palette, isBlocked, isMismatched, size: 9.0),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 6),
              child: _buildClayBead(palette, isBlocked, isMismatched, size: 9.0),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 6),
              child: _buildClayBead(palette, isBlocked, isMismatched, size: 9.0),
            ),
          ),
        ],
      );
    } else if (value == 7) {
      // Tile 7: 3 beads on left column, 4 beads on right (2x2 grid)
      return Stack(
        children: [
          Center(
            child: Text(
              '$value',
              style: textStyle,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
                  (i) => _buildClayBead(palette, isBlocked, isMismatched, size: 8.5),
                ),
              ),
            ),
          ),
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
                      _buildClayBead(palette, isBlocked, isMismatched, size: 7.6),
                      const SizedBox(width: 2.5),
                      _buildClayBead(palette, isBlocked, isMismatched, size: 7.6),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildClayBead(palette, isBlocked, isMismatched, size: 7.6),
                      const SizedBox(width: 2.5),
                      _buildClayBead(palette, isBlocked, isMismatched, size: 7.6),
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
          const SizedBox(height: 1),
          _buildClayBead(palette, isBlocked, isMismatched, size: 9.5),
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
          const SizedBox(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildClayBead(palette, isBlocked, isMismatched, size: 9.0),
              const SizedBox(width: 7),
              _buildClayBead(palette, isBlocked, isMismatched, size: 9.0),
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
                    (i) => _buildClayBead(palette, isBlocked, isMismatched, size: 8.5),
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
                    (i) => _buildClayBead(palette, isBlocked, isMismatched, size: 8.5),
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
          style: textStyle.copyWith(fontSize: 38),
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
        ? const Color(0xFF8C7561)
        : (isMismatched ? AppColors.accentCoral : palette.primary);

    final dark = isBlocked
        ? const Color(0xFF6B5442)
        : (isMismatched ? AppColors.accentCoralDark : palette.dark);

    final highlight = isBlocked
        ? const Color(0xFFBDB0A2)
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            offset: Offset(0.5, 1.2),
            blurRadius: 1.2,
          ),
        ],
      ),
    );
  }
}

/// Custom painter for subtle, gentle organic wood texture
class _SoftWoodGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8F5828)
      ..strokeWidth = 1.0
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
