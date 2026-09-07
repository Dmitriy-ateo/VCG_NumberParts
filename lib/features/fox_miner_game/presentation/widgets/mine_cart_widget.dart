import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

enum MineCartType {
  tens,
  singles,
}

class MineCartWidget extends StatefulWidget {
  final MineCartType type;
  final int count;
  final String label;
  final bool isFull;
  final String? fullBadgeText;
  final VoidCallback? onTap;

  const MineCartWidget({
    super.key,
    required this.type,
    required this.count,
    required this.label,
    this.isFull = false,
    this.fullBadgeText,
    this.onTap,
  });

  @override
  State<MineCartWidget> createState() => _MineCartWidgetState();
}

class _MineCartWidgetState extends State<MineCartWidget>
    with TickerProviderStateMixin {
  late AnimationController _bumpController;
  late Animation<double> _bumpAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _bumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _bumpAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 0.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _bumpController, curve: Curves.easeOut));

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.07), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.07, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    if (widget.isFull) {
      _pulseController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant MineCartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count && widget.count > 0) {
      _bumpController.forward(from: 0.0);
    }
    if (widget.isFull != oldWidget.isFull) {
      if (widget.isFull) {
        _pulseController.repeat();
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _bumpController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTens = widget.type == MineCartType.tens;
    final gemEmoji = isTens ? '💎' : '✨';

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([_bumpAnimation, _pulseAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bumpAnimation.value),
            child: Transform.scale(
              scale: widget.isFull ? _pulseAnimation.value : 1.0,
              child: child,
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cart Container
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Full Badge above cart
                if (widget.isFull)
                  Positioned(
                    top: -34,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF922B), Color(0xFFFA5252)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF922B).withValues(alpha: 0.6),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('✨ ', style: TextStyle(fontSize: 10)),
                          Text(
                            widget.fullBadgeText ?? '10! FULL ➔',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Overflowing crystal gems if count > 0
                if (widget.count > 0)
                  Positioned(
                    top: -14,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          gemEmoji,
                          style: TextStyle(fontSize: isTens ? 22 : 18),
                        ),
                        if (isTens && widget.count >= 20)
                          const Text('💎', style: TextStyle(fontSize: 20)),
                        if (isTens && widget.count >= 50)
                          const Text('💎', style: TextStyle(fontSize: 22)),
                        if (!isTens && widget.count >= 3)
                          const Text('✨', style: TextStyle(fontSize: 18)),
                        if (!isTens && widget.count >= 10)
                          const Text('✨', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),

                // Wooden/Iron Mine Cart
                Container(
                  width: isTens ? 120 : 100,
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: widget.isFull
                          ? [
                              const Color(0xFFA0522D),
                              const Color(0xFF6E2C00),
                            ]
                          : [
                              const Color(0xFF8D6E63),
                              const Color(0xFF5D4037),
                            ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    border: Border.all(
                      color: widget.isFull
                          ? const Color(0xFFFFD43B)
                          : const Color(0xFF3E2723),
                      width: widget.isFull ? 3.0 : 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.isFull
                            ? const Color(0xFFFF922B).withValues(alpha: 0.5)
                            : Colors.black.withValues(alpha: 0.2),
                        blurRadius: widget.isFull ? 12 : 6,
                        spreadRadius: widget.isFull ? 2 : 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${widget.count}',
                      style: AppTextStyles.numberTile.copyWith(
                        fontSize: isTens ? 24 : 22,
                        color: widget.isFull
                            ? const Color(0xFFFFF3BF)
                            : const Color(0xFFFFE082),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            offset: const Offset(0, 1.5),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Wheels
              Positioned(
                bottom: -8,
                left: 14,
                child: _buildWheel(),
              ),
              Positioned(
                bottom: -8,
                right: 14,
                child: _buildWheel(),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Label
          Text(
            widget.label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildWheel() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: const Color(0xFF424242),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF9E9E9E),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
