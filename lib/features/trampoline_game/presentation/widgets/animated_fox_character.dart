import 'dart:math';
import 'package:flutter/material.dart';
import 'package:number_parts/app/theme/app_text_styles.dart';
import 'package:number_parts/features/trampoline_game/domain/models/fox_animation_state.dart';

class AnimatedFoxCharacter extends StatefulWidget {
  final FoxAnimationState state;
  final int? targetNumber;
  final double tilt;
  final double width;
  final double height;

  const AnimatedFoxCharacter({
    super.key,
    required this.state,
    this.targetNumber,
    this.tilt = 0.0,
    this.width = 120,
    this.height = 140,
  });

  @override
  State<AnimatedFoxCharacter> createState() => _AnimatedFoxCharacterState();
}

class _AnimatedFoxCharacterState extends State<AnimatedFoxCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _idleAnim;

  @override
  void initState() {
    super.initState();
    _idleAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _idleAnim.dispose();
    super.dispose();
  }

  String get _frameAssetPath {
    switch (widget.state) {
      case FoxAnimationState.flyingUp:
        return 'assets/images/fox_flying_up.png';
      case FoxAnimationState.falling:
      case FoxAnimationState.idle:
        return 'assets/images/fox_falling.png';
      case FoxAnimationState.touchingTrampoline:
        return 'assets/images/fox_touching.png';
      case FoxAnimationState.fallen:
        return 'assets/images/fox_fallen.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _idleAnim,
      builder: (context, child) {
        final t = _idleAnim.value;
        double scaleX = 1.0;
        double scaleY = 1.0;
        double rotation = widget.tilt;
        double offsetY = 0.0;

        switch (widget.state) {
          case FoxAnimationState.flyingUp:
            scaleX = 0.95;
            scaleY = 1.08;
            rotation += (t - 0.5) * 0.06;
            offsetY = -6;
            break;
          case FoxAnimationState.falling:
            scaleX = 1.02;
            scaleY = 0.98;
            rotation += sin(t * pi * 2) * 0.05;
            offsetY = sin(t * pi * 2) * 4;
            break;
          case FoxAnimationState.touchingTrampoline:
            scaleX = 1.25;
            scaleY = 0.80;
            offsetY = 12;
            break;
          case FoxAnimationState.fallen:
            scaleX = 1.10;
            scaleY = 0.92;
            offsetY = 6;
            break;
          case FoxAnimationState.idle:
            rotation += sin(t * pi * 2) * 0.03;
            offsetY = (t - 0.5) * 3;
            break;
        }

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(0.0, offsetY)
            ..rotateZ(rotation)
            ..scale(scaleX, scaleY),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // ── SPEED TRAILS (When Flying Up) ─────────────────────
                if (widget.state == FoxAnimationState.flyingUp)
                  Positioned(
                    bottom: -15,
                    child: _buildSpeedTrails(),
                  ),

                // ── 3D MASCOT FOX CHARACTER FRAME ─────────────────────
                Image.asset(
                  _frameAssetPath,
                  width: widget.width,
                  height: widget.height,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                ),

                // ── TARGET NUMBER WOODEN PLAQUE ────────────────────────
                if (widget.targetNumber != null &&
                    widget.state != FoxAnimationState.fallen)
                  Positioned(
                    bottom: widget.state == FoxAnimationState.flyingUp
                        ? 22
                        : (widget.state == FoxAnimationState.touchingTrampoline
                            ? 12
                            : 16),
                    child: _buildTargetPlaque(widget.targetNumber!),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTargetPlaque(int number) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFEECC), Color(0xFFFFD899)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD49A55),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A5A2B).withOpacity(0.35),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🎯 ',
            style: TextStyle(fontSize: 14),
          ),
          Text(
            '$number',
            style: AppTextStyles.numberTile.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF8A5A2B),
              shadows: [
                const Shadow(
                  color: Colors.white70,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedTrails() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTrailBar(height: 28, opacity: 0.6),
        const SizedBox(width: 8),
        _buildTrailBar(height: 42, opacity: 0.9),
        const SizedBox(width: 8),
        _buildTrailBar(height: 24, opacity: 0.5),
      ],
    );
  }

  Widget _buildTrailBar({required double height, required double opacity}) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(opacity),
            Colors.white.withOpacity(0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
