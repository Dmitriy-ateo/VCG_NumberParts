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

        // ── LUSH GREEN MEADOW GROUND ─────────────────────────────────
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 120,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF86EFAC), // Fresh meadow light green
                  Color(0xFF4ADE80), // Vibrant grass green
                  Color(0xFF22C55E), // Deep lush grass
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF15803D).withOpacity(0.20),
                  offset: const Offset(0, -4),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
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
