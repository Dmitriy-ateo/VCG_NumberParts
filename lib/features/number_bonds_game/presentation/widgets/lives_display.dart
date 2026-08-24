import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class LivesDisplay extends StatelessWidget {
  final int lives;
  final int maxLives;

  const LivesDisplay({
    super.key,
    required this.lives,
    this.maxLives = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.woodBorder.withAlpha(140),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowWarm,
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(maxLives, (index) {
          final isAlive = index < lives;
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 6),
            child: _HeartItem(isAlive: isAlive, index: index),
          );
        }),
      ),
    );
  }
}

class _HeartItem extends StatefulWidget {
  final bool isAlive;
  final int index;

  const _HeartItem({
    required this.isAlive,
    required this.index,
  });

  @override
  State<_HeartItem> createState() => _HeartItemState();
}

class _HeartItemState extends State<_HeartItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;
  bool _wasAlive = true;

  @override
  void initState() {
    super.initState();
    _wasAlive = widget.isAlive;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.45)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.45, end: 0.8)
            .chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 60,
      ),
    ]).animate(_controller);

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant _HeartItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isAlive && !widget.isAlive) {
      // Just lost this heart! Trigger removal animation
      _controller.forward(from: 0.0);
    } else if (!oldWidget.isAlive && widget.isAlive) {
      // Restored heart
      _controller.reset();
    }
    _wasAlive = widget.isAlive;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAlive && !_controller.isAnimating && !_wasAlive) {
      return const Opacity(
        opacity: 0.25,
        child: Text(
          '🤍',
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final isAnimatingLoss = _controller.isAnimating;
        final scale = isAnimatingLoss ? _scaleAnimation.value : (widget.isAlive ? 1.0 : 0.8);
        final shake = isAnimatingLoss
            ? math.sin(_shakeAnimation.value * math.pi * 5.0) * 4.0
            : 0.0;

        return Transform.translate(
          offset: Offset(shake, 0),
          child: Transform.scale(
            scale: scale,
            child: Text(
              isAnimatingLoss
                  ? (_controller.value < 0.45 ? '💔' : '🤍')
                  : (widget.isAlive ? '❤️' : '🤍'),
              style: TextStyle(
                fontSize: 20,
                shadows: widget.isAlive
                    ? const [
                        BoxShadow(
                          color: AppColors.accentCoral,
                          blurRadius: 6,
                        ),
                      ]
                    : [],
              ),
            ),
          ),
        );
      },
    );
  }
}
