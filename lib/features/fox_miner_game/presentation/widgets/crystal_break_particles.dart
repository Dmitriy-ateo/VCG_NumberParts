import 'dart:math';
import 'package:flutter/material.dart';

class CrystalShard {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double rotation;
  double vRotation;
  Color color;
  double opacity;

  CrystalShard({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.rotation,
    required this.vRotation,
    required this.color,
    this.opacity = 1.0,
  });
}

class FlyingCrystal {
  final Offset from;
  final Offset to;
  final Offset control;
  final String imagePath;
  final double size;
  final Color colorTint;
  final VoidCallback? onArrival;
  double progress;

  FlyingCrystal({
    required this.from,
    required this.to,
    required this.control,
    required this.imagePath,
    required this.size,
    required this.colorTint,
    this.onArrival,
    this.progress = 0.0,
  });

  Offset get currentPosition {
    final t = progress.clamp(0.0, 1.0);
    final invT = 1.0 - t;
    return Offset(
      invT * invT * from.dx + 2 * invT * t * control.dx + t * t * to.dx,
      invT * invT * from.dy + 2 * invT * t * control.dy + t * t * to.dy,
    );
  }
}

class CrystalBreakParticlesOverlay extends StatefulWidget {
  final Widget child;

  const CrystalBreakParticlesOverlay({
    super.key,
    required this.child,
  });

  static CrystalBreakParticlesOverlayState? of(BuildContext context) {
    return context.findAncestorStateOfType<CrystalBreakParticlesOverlayState>();
  }

  @override
  State<CrystalBreakParticlesOverlay> createState() =>
      CrystalBreakParticlesOverlayState();
}

class CrystalBreakParticlesOverlayState
    extends State<CrystalBreakParticlesOverlay>
    with SingleTickerProviderStateMixin {
  final List<CrystalShard> _shards = [];
  final List<FlyingCrystal> _flyingCrystals = [];
  late AnimationController _animController;
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_tick);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _tick() {
    if (_shards.isEmpty && _flyingCrystals.isEmpty) {
      _animController.stop();
      return;
    }

    setState(() {
      for (int i = _shards.length - 1; i >= 0; i--) {
        final shard = _shards[i];
        shard.x += shard.vx;
        shard.y += shard.vy;
        shard.vy += 0.35; // gravity
        shard.rotation += shard.vRotation;
        shard.opacity -= 0.025; // fade out

        if (shard.opacity <= 0) {
          _shards.removeAt(i);
        }
      }

      for (int i = _flyingCrystals.length - 1; i >= 0; i--) {
        final fc = _flyingCrystals[i];
        fc.progress += 0.055;
        if (fc.progress >= 1.0) {
          fc.onArrival?.call();
          spawnBurst(origin: fc.to, isBigBurst: false, colorTint: fc.colorTint);
          _flyingCrystals.removeAt(i);
        }
      }
    });

    if ((_shards.isNotEmpty || _flyingCrystals.isNotEmpty) && !_animController.isAnimating) {
      _animController.repeat();
    }
  }

  /// Spawns an animated crystal flying in an arc to the cart
  void spawnFlyingCrystal({
    required Offset from,
    required Offset to,
    required String imagePath,
    required double size,
    Color? colorTint,
    VoidCallback? onArrival,
  }) {
    final midX = (from.dx + to.dx) / 2;
    final arcPeak = min(from.dy, to.dy) - 70;
    _flyingCrystals.add(
      FlyingCrystal(
        from: from,
        to: to,
        control: Offset(midX, arcPeak),
        imagePath: imagePath,
        size: size,
        colorTint: colorTint ?? const Color(0xFF9775FA),
        onArrival: onArrival,
      ),
    );

    if (!_animController.isAnimating) {
      _animController.repeat();
    }
  }

  /// Spawns crystal shards bursting from an origin point
  void spawnBurst({
    required Offset origin,
    required bool isBigBurst,
    Color? colorTint,
  }) {
    final count = isBigBurst ? 32 : 12;
    final baseColor = colorTint ?? const Color(0xFF6741D9);

    final colors = [
      baseColor,
      const Color(0xFF9775FA),
      const Color(0xFF74C0FC),
      const Color(0xFFE599F7),
      Colors.white,
    ];

    for (int i = 0; i < count; i++) {
      final angle = _rng.nextDouble() * 2 * pi;
      final speed = (isBigBurst ? 4.0 : 2.5) + _rng.nextDouble() * (isBigBurst ? 8.0 : 4.5);

      _shards.add(
        CrystalShard(
          x: origin.dx,
          y: origin.dy,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed - (isBigBurst ? 3.0 : 1.5),
          size: 6.0 + _rng.nextDouble() * (isBigBurst ? 12.0 : 6.0),
          rotation: _rng.nextDouble() * 2 * pi,
          vRotation: (_rng.nextDouble() - 0.5) * 0.3,
          color: colors[_rng.nextInt(colors.length)],
          opacity: 1.0,
        ),
      );
    }

    if (!_animController.isAnimating) {
      _animController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_shards.isNotEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ShardsPainter(_shards),
              ),
            ),
          ),
        for (final fc in _flyingCrystals)
          Positioned(
            left: fc.currentPosition.dx - fc.size / 2,
            top: fc.currentPosition.dy - fc.size / 2,
            child: IgnorePointer(
              child: Transform.rotate(
                angle: fc.progress * pi * 2,
                child: Transform.scale(
                  scale: 1.0 + sin(fc.progress * pi) * 0.35,
                  child: Image.asset(
                    fc.imagePath,
                    width: fc.size,
                    height: fc.size,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ShardsPainter extends CustomPainter {
  final List<CrystalShard> shards;

  _ShardsPainter(this.shards);

  @override
  void paint(Canvas canvas, Size size) {
    for (final shard in shards) {
      final paint = Paint()
        ..color = shard.color.withValues(alpha: shard.opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(shard.x, shard.y);
      canvas.rotate(shard.rotation);

      // Draw diamond / triangular crystal shard
      final path = Path()
        ..moveTo(0, -shard.size)
        ..lineTo(shard.size * 0.6, 0)
        ..lineTo(0, shard.size)
        ..lineTo(-shard.size * 0.6, 0)
        ..close();

      canvas.drawPath(path, paint);

      // Inner sparkle highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: (shard.opacity * 0.8).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      final highlightPath = Path()
        ..moveTo(0, -shard.size * 0.5)
        ..lineTo(shard.size * 0.25, 0)
        ..lineTo(0, shard.size * 0.5)
        ..lineTo(-shard.size * 0.25, 0)
        ..close();

      canvas.drawPath(highlightPath, highlightPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ShardsPainter oldDelegate) => true;
}
