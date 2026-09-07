import 'package:flutter/material.dart';

enum MinerRole {
  mom,
  kid,
}

class MinerCharacterButton extends StatefulWidget {
  final MinerRole role;
  final VoidCallback onTap;
  final double size;
  final bool flipX;

  const MinerCharacterButton({
    super.key,
    required this.role,
    required this.onTap,
    this.size = 200.0,
    this.flipX = false,
  });

  @override
  State<MinerCharacterButton> createState() => _MinerCharacterButtonState();
}

class _MinerCharacterButtonState extends State<MinerCharacterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _swingController;
  late Animation<double> _swingAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _swingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _swingAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.08), weight: 35),
      TweenSequenceItem(tween: Tween(begin: -0.08, end: 0.05), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 0.05, end: 0.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _swingController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _swingController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _swingController.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isMom = widget.role == MinerRole.mom;
    final imagePath = isMom
        ? 'assets/images/mom_fox_miner.png'
        : 'assets/images/kid_fox_miner.png';

    final size = widget.size;

    return AnimatedBuilder(
      animation: _swingAnimation,
      builder: (context, child) {
        final scale = _isPressed ? 0.94 : 1.0;
        final rotation = widget.flipX ? -_swingAnimation.value : _swingAnimation.value;
        return Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: rotation,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        key: ValueKey('miner_character_${widget.role.name}'),
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _handleTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: size,
          height: size,
          child: Transform.flip(
            flipX: widget.flipX,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
