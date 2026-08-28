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
                  Color(0xFFE3FAFC),
                  Color(0xFFD3F9D8),
                  Color(0xFFFFF9DB),
                  Color(0xFFFDF8F0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.45, 0.85, 1.0],
              ),
            ),
          ),
        ),

        // ── FLOATING CLOUDS ──────────────────────────────────────────
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

                // Cloud 1
                Positioned(
                  top: 80,
                  left: ((t * (width + 120)) % (width + 160)) - 100,
                  child: _buildCloud(80, 36),
                ),

                // Cloud 2
                Positioned(
                  top: 160,
                  left: (((t + 0.5) * (width + 140)) % (width + 180)) - 120,
                  child: _buildCloud(110, 44),
                ),

                // Cloud 3
                Positioned(
                  top: 260,
                  left: (((t + 0.25) * (width + 100)) % (width + 150)) - 80,
                  child: _buildCloud(70, 32),
                ),
              ],
            );
          },
        ),

        // ── FOREGROUND CONTENT ───────────────────────────────────────
        widget.child,
      ],
    );
  }

  Widget _buildCloud(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(h / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}
