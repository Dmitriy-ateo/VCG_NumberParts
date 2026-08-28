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
    this.width = 110,
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
            scaleX = 0.90;
            scaleY = 1.18;
            rotation += (t - 0.5) * 0.08;
            offsetY = -6;
            break;
          case FoxAnimationState.falling:
            scaleX = 1.02;
            scaleY = 0.98;
            rotation += sin(t * pi * 2) * 0.06;
            offsetY = sin(t * pi * 2) * 3;
            break;
          case FoxAnimationState.touchingTrampoline:
            scaleX = 1.38;
            scaleY = 0.65;
            offsetY = 14;
            break;
          case FoxAnimationState.fallen:
            scaleX = 1.15;
            scaleY = 0.88;
            offsetY = 8;
            break;
          case FoxAnimationState.idle:
            rotation += sin(t * pi * 2) * 0.04;
            offsetY = (t - 0.5) * 4;
            break;
        }

        return Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..translate(0.0, offsetY)
            ..rotateZ(rotation)
            ..scale(scaleX, scaleY),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // ── SPEED TRAILS (When Flying Up) ─────────────────────
                if (widget.state == FoxAnimationState.flyingUp)
                  Positioned(
                    bottom: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 4,
                          height: 24.0 + (i == 1 ? 12 : 0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                  ),

                // ── ORBITING STARS (When Fallen / Dizzy) ───────────────
                if (widget.state == FoxAnimationState.fallen)
                  Positioned(
                    top: -4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.rotate(
                          angle: t * pi,
                          child: const Text('💫', style: TextStyle(fontSize: 20)),
                        ),
                        const SizedBox(width: 14),
                        Transform.rotate(
                          angle: -t * pi,
                          child: const Text('⭐', style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),

                // ── FOX ILLUSTRATION PAINTER ──────────────────────────
                Positioned.fill(
                  child: CustomPaint(
                    painter: _FoxPainter(
                      state: widget.state,
                      animProgress: t,
                    ),
                  ),
                ),

                // ── HELD WOODEN TARGET NUMBER PLAQUE ───────────────────
                if (widget.targetNumber != null &&
                    widget.state != FoxAnimationState.fallen)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFEECC), Color(0xFFFFD899)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFD49A55),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8A5A2B).withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Text(
                        '${widget.targetNumber}',
                        style: AppTextStyles.numberTile.copyWith(
                          fontSize: 24,
                          color: const Color(0xFFE8590C),
                          shadows: [
                            const Shadow(
                              color: Color(0xFF8E3B06),
                              offset: Offset(0, 1.5),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FoxPainter extends CustomPainter {
  final FoxAnimationState state;
  final double animProgress;

  _FoxPainter({required this.state, required this.animProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.44;

    // Colors
    final furOrange = const Color(0xFFF76707);
    final furOrangeDark = const Color(0xFFD9480F);
    final whiteFur = const Color(0xFFFFF9DB);
    final earInner = const Color(0xFFFFC9C9);
    final eyeBlack = const Color(0xFF212529);

    final paint = Paint()..isAntiAlias = true;

    // ── 1. FLUFFY TAIL (Behind) ───────────────────────────────────────
    final tailPath = Path();
    final tailWag = state == FoxAnimationState.flyingUp
        ? 0.0
        : sin(animProgress * pi * 2) * 6.0;

    tailPath.moveTo(cx + 26, cy + 18);
    tailPath.quadraticBezierTo(
      cx + 52 + tailWag,
      cy - 10,
      cx + 42 + tailWag,
      cy - 34,
    );
    tailPath.quadraticBezierTo(
      cx + 24,
      cy - 14,
      cx + 18,
      cy + 16,
    );
    tailPath.close();

    paint.color = furOrangeDark;
    canvas.drawPath(tailPath, paint);

    // Tail White Tip
    final tailTip = Path();
    tailTip.moveTo(cx + 36 + tailWag, cy - 22);
    tailTip.quadraticBezierTo(
      cx + 52 + tailWag,
      cy - 10,
      cx + 42 + tailWag,
      cy - 34,
    );
    tailTip.quadraticBezierTo(
      cx + 28,
      cy - 24,
      cx + 36 + tailWag,
      cy - 22,
    );
    tailTip.close();
    paint.color = whiteFur;
    canvas.drawPath(tailTip, paint);

    // ── 2. EARS ───────────────────────────────────────────────────────
    // Left Ear
    final leftEar = Path();
    final earSpread = state == FoxAnimationState.flyingUp ? -4.0 : 0.0;
    leftEar.moveTo(cx - 24, cy - 14);
    leftEar.lineTo(cx - 36 + earSpread, cy - 42);
    leftEar.lineTo(cx - 10, cy - 24);
    leftEar.close();
    paint.color = furOrangeDark;
    canvas.drawPath(leftEar, paint);

    // Left Ear Inner Pink
    final leftEarIn = Path();
    leftEarIn.moveTo(cx - 22, cy - 16);
    leftEarIn.lineTo(cx - 32 + earSpread, cy - 36);
    leftEarIn.lineTo(cx - 12, cy - 23);
    leftEarIn.close();
    paint.color = earInner;
    canvas.drawPath(leftEarIn, paint);

    // Right Ear
    final rightEar = Path();
    rightEar.moveTo(cx + 24, cy - 14);
    rightEar.lineTo(cx + 36 - earSpread, cy - 42);
    rightEar.lineTo(cx + 10, cy - 24);
    rightEar.close();
    paint.color = furOrangeDark;
    canvas.drawPath(rightEar, paint);

    // Right Ear Inner Pink
    final rightEarIn = Path();
    rightEarIn.moveTo(cx + 22, cy - 16);
    rightEarIn.lineTo(cx + 32 - earSpread, cy - 36);
    rightEarIn.lineTo(cx + 12, cy - 23);
    rightEarIn.close();
    paint.color = earInner;
    canvas.drawPath(rightEarIn, paint);

    // ── 3. FOX BODY & HEAD ────────────────────────────────────────────
    // Main Head Oval
    paint.color = furOrange;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: 62, height: 54),
      paint,
    );

    // Cheeks & Muzzle White Fluff
    final cheeksPath = Path();
    cheeksPath.moveTo(cx - 30, cy + 2);
    cheeksPath.quadraticBezierTo(cx - 38, cy + 18, cx - 18, cy + 26);
    cheeksPath.lineTo(cx + 18, cy + 26);
    cheeksPath.quadraticBezierTo(cx + 38, cy + 18, cx + 30, cy + 2);
    cheeksPath.quadraticBezierTo(cx, cy + 10, cx - 30, cy + 2);
    cheeksPath.close();
    paint.color = whiteFur;
    canvas.drawPath(cheeksPath, paint);

    // ── 4. EYES ───────────────────────────────────────────────────────
    paint.color = eyeBlack;
    if (state == FoxAnimationState.fallen) {
      // Dizzy Spiral X eyes
      _drawDizzyEye(canvas, cx - 14, cy - 4);
      _drawDizzyEye(canvas, cx + 14, cy - 4);
    } else if (state == FoxAnimationState.touchingTrampoline ||
        state == FoxAnimationState.flyingUp) {
      // Joyful squinting curve eyes (^_^)
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 3.0;
      paint.strokeCap = StrokeCap.round;

      final leftEyePath = Path()
        ..moveTo(cx - 18, cy - 2)
        ..quadraticBezierTo(cx - 13, cy - 8, cx - 8, cy - 2);
      canvas.drawPath(leftEyePath, paint);

      final rightEyePath = Path()
        ..moveTo(cx + 8, cy - 2)
        ..quadraticBezierTo(cx + 13, cy - 8, cx + 18, cy - 2);
      canvas.drawPath(rightEyePath, paint);
      paint.style = PaintingStyle.fill;
    } else {
      // Big friendly sparkle cartoon eyes
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx - 13, cy - 4), width: 8, height: 11),
        paint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx + 13, cy - 4), width: 8, height: 11),
        paint,
      );

      // Eye Sparkle Highlights
      paint.color = Colors.white;
      canvas.drawCircle(Offset(cx - 15, cy - 7), 2.5, paint);
      canvas.drawCircle(Offset(cx + 11, cy - 7), 2.5, paint);
      paint.color = eyeBlack;
    }

    // ── 5. CUTE NOSE & SMILE ──────────────────────────────────────────
    // Nose
    paint.color = const Color(0xFF212529);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 10), width: 7, height: 5),
      paint,
    );

    // Cute Smile
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.2;
    paint.strokeCap = StrokeCap.round;
    final mouthPath = Path();
    mouthPath.moveTo(cx - 6, cy + 16);
    mouthPath.quadraticBezierTo(cx, cy + 20, cx + 6, cy + 16);
    canvas.drawPath(mouthPath, paint);
    paint.style = PaintingStyle.fill;

    // Cheeks Rosy Blush
    paint.color = const Color(0xFFFF8787).withOpacity(0.55);
    canvas.drawCircle(Offset(cx - 21, cy + 8), 5.0, paint);
    canvas.drawCircle(Offset(cx + 21, cy + 8), 5.0, paint);

    // ── 6. FRONT PAWS ─────────────────────────────────────────────────
    paint.color = whiteFur;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 22, cy + 28), width: 12, height: 14),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 22, cy + 28), width: 12, height: 14),
      paint,
    );
  }

  void _drawDizzyEye(Canvas canvas, double ex, double ey) {
    final paint = Paint()
      ..color = const Color(0xFF212529)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(ex - 5, ey - 5), Offset(ex + 5, ey + 5), paint);
    canvas.drawLine(Offset(ex + 5, ey - 5), Offset(ex - 5, ey + 5), paint);
  }

  @override
  bool shouldRepaint(covariant _FoxPainter oldDelegate) {
    return oldDelegate.state != state || oldDelegate.animProgress != animProgress;
  }
}
