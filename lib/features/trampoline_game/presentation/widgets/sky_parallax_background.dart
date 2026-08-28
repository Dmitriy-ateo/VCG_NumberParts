import 'dart:math';
import 'package:flutter/material.dart';

class SkyParallaxBackground extends StatefulWidget {
  final Widget child;

  const SkyParallaxBackground({super.key, required this.child});

  @override
  State<SkyParallaxBackground> createState() => _SkyParallaxBackgroundState();
}

class _SkyParallaxBackgroundState extends State<SkyParallaxBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _driftAnim;

  @override
  void initState() {
    super.initState();
    _driftAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _driftAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── SKY GRADIENT ─────────────────────────────────────────────
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7DD3FC), // Crisp sky blue
                  Color(0xFFBAE6FD), // Soft pastel sky
                  Color(0xFFE0F2FE), // Airy horizon
                  Color(0xFFFEF3C7), // Sunny golden horizon
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.35, 0.70, 1.0],
              ),
            ),
          ),
        ),

        // ── FLOATING CLOUDS & SUN ─────────────────────────────────────
        AnimatedBuilder(
          animation: _driftAnim,
          builder: (context, _) {
            final t = _driftAnim.value;
            final width = MediaQuery.of(context).size.width;

            return Stack(
              children: [
                // Top Sun
                Positioned(
                  top: 24,
                  right: 28,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFE066),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD43B).withOpacity(0.55),
                          blurRadius: 20,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),

                // Cloud 1 (High sky)
                Positioned(
                  top: 60,
                  left: ((width + 120) * t - 100) % (width + 200) - 80,
                  child: _buildCloud(scale: 1.1, opacity: 0.85),
                ),

                // Cloud 2 (Mid sky, drifting slower)
                Positioned(
                  top: 150,
                  left: ((width + 150) * ((t + 0.5) % 1.0) - 100) % (width + 220) - 90,
                  child: _buildCloud(scale: 0.85, opacity: 0.65),
                ),

                // Cloud 3 (Lower sky)
                Positioned(
                  top: 240,
                  left: ((width + 130) * ((t + 0.8) % 1.0) - 80) % (width + 200) - 70,
                  child: _buildCloud(scale: 0.70, opacity: 0.50),
                ),
              ],
            );
          },
        ),

        // ── NATURAL ROLLING MEADOW HILLS ────────────────────────────
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 220,
          child: const MeadowHillsBackground(),
        ),

        // Content
        Positioned.fill(child: widget.child),
      ],
    );
  }

  Widget _buildCloud({required double scale, required double opacity}) {
    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: SizedBox(
          width: 90,
          height: 38,
          child: Stack(
            children: [
              Positioned(
                left: 10,
                top: 8,
                child: Container(
                  width: 32,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 28,
                top: 0,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 52,
                top: 10,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 0,
                child: Container(
                  width: 62,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painted organic rolling hills and sunny meadow land
class MeadowHillsBackground extends StatelessWidget {
  const MeadowHillsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _MeadowHillsPainter(),
      size: Size.infinite,
    );
  }
}

class _MeadowHillsPainter extends CustomPainter {
  const _MeadowHillsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── 1. DISTANT BACKGROUND ROLLING HILL ────────────────────────
    final backHillPath = Path();
    backHillPath.moveTo(0, h * 0.42);
    backHillPath.cubicTo(
      w * 0.28,
      h * 0.20,
      w * 0.68,
      h * 0.52,
      w,
      h * 0.32,
    );
    backHillPath.lineTo(w, h);
    backHillPath.lineTo(0, h);
    backHillPath.close();

    final backHillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFD9F99D), // Soft sunlit lime pastel
          Color(0xFFA7F3D0), // Soft mint green
          Color(0xFF86EFAC), // Light meadow green
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(backHillPath, backHillPaint);

    // ── 2. MID-GROUND SUNNY ROLLING HILL ──────────────────────────
    final midHillPath = Path();
    midHillPath.moveTo(0, h * 0.48);
    midHillPath.cubicTo(
      w * 0.38,
      h * 0.65,
      w * 0.72,
      h * 0.32,
      w,
      h * 0.45,
    );
    midHillPath.lineTo(w, h);
    midHillPath.lineTo(0, h);
    midHillPath.close();

    final midHillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFBAF7D0), // Sunlit warm light green
          Color(0xFF86EFAC), // Fresh meadow green
          Color(0xFF4ADE80), // Vibrant grass green
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(midHillPath, midHillPaint);

    // ── 3. MAIN FOREGROUND MEADOW GROUND ──────────────────────────
    final foreHillPath = Path();
    foreHillPath.moveTo(0, h * 0.58);
    foreHillPath.cubicTo(
      w * 0.30,
      h * 0.46,
      w * 0.70,
      h * 0.54,
      w,
      h * 0.50,
    );
    foreHillPath.lineTo(w, h);
    foreHillPath.lineTo(0, h);
    foreHillPath.close();

    final foreHillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFC7F9CC), // Pale sunny grass highlight
          Color(0xFF86EFAC), // Meadow green
          Color(0xFF4ADE80), // Vibrant grass
          Color(0xFF22C55E), // Lush rich grass
        ],
        stops: [0.0, 0.25, 0.65, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(foreHillPath, foreHillPaint);

    // ── 4. SUBTLE SUNNY WILDFLOWER ACCENTS ─────────────────────────
    final flowerPaint = Paint()..color = const Color(0xFFFEF9C3);
    final flowerCenterPaint = Paint()..color = const Color(0xFFF59E0B);

    final flowerLocations = [
      Offset(w * 0.08, h * 0.72),
      Offset(w * 0.18, h * 0.88),
      Offset(w * 0.35, h * 0.78),
      Offset(w * 0.52, h * 0.85),
      Offset(w * 0.68, h * 0.74),
      Offset(w * 0.85, h * 0.82),
      Offset(w * 0.93, h * 0.70),
    ];

    for (final pos in flowerLocations) {
      canvas.drawCircle(pos, 3.5, flowerPaint);
      canvas.drawCircle(pos, 1.5, flowerCenterPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
