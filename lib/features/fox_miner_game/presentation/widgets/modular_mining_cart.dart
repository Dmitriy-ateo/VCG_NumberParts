import 'package:flutter/material.dart';
import '../../../../app/theme/app_text_styles.dart';
import 'miner_character_button.dart';

class ModularMiningCart extends StatefulWidget {
  final MinerRole role;
  final int count;
  final bool isFull;
  final String? blockedBadgeLabel;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final bool flipX;

  const ModularMiningCart({
    super.key,
    required this.role,
    required this.count,
    this.isFull = false,
    this.blockedBadgeLabel,
    this.onTap,
    this.width = 175,
    this.height = 145,
    this.flipX = false,
  });

  @override
  State<ModularMiningCart> createState() => _ModularMiningCartState();
}

class _ModularMiningCartState extends State<ModularMiningCart>
    with TickerProviderStateMixin {
  late AnimationController _bumpController;
  late Animation<double> _bumpAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

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
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    if (widget.isFull) {
      _pulseController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ModularMiningCart oldWidget) {
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

  int get _stageIndex {
    if (widget.role == MinerRole.mom) {
      return (widget.count ~/ 10).clamp(0, 10);
    } else {
      return widget.count.clamp(0, 10);
    }
  }

  String get _cartImagePath {
    final prefix = widget.role == MinerRole.mom ? 'cart_mom' : 'cart_kid';
    return 'assets/images/carts/${prefix}_$_stageIndex.png';
  }

  @override
  Widget build(BuildContext context) {
    final isMom = widget.role == MinerRole.mom;

    return GestureDetector(
      key: ValueKey('cart_button_${widget.role.name}'),
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([_bumpAnimation, _pulseAnimation]),
        builder: (context, child) {
          final scale = widget.isFull
              ? _pulseAnimation.value
              : (_isPressed ? 0.95 : 1.0);
          return Transform.translate(
            offset: Offset(0, _bumpAnimation.value),
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          );
        },
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Cart 3D fulfillment illustration
              Positioned.fill(
                child: Transform.flip(
                  flipX: widget.flipX,
                  child: Image.asset(
                    _cartImagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Full Badge above cart when full
              if (widget.isFull)
                Positioned(
                  top: -12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF922B), Color(0xFFFA5252)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF922B).withValues(alpha: 0.65),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('✨ ', style: TextStyle(fontSize: 11)),
                        Text(
                          widget.blockedBadgeLabel ?? '10! FULL',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Count Badge below / anchored to cart
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4E342E),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: widget.isFull
                          ? const Color(0xFFFFD43B)
                          : const Color(0xFFD7CCC8),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isMom ? '💎' : '✨',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.count}',
                        key: ValueKey('miner_count_${widget.role.name}'),
                        style: AppTextStyles.numberTile.copyWith(
                          fontSize: 18,
                          color: const Color(0xFFFFE082),
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
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
