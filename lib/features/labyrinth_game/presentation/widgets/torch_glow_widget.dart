import 'package:flutter/material.dart';

class TorchGlowWidget extends StatefulWidget {
  const TorchGlowWidget({super.key});

  @override
  State<TorchGlowWidget> createState() => _TorchGlowWidgetState();
}

class _TorchGlowWidgetState extends State<TorchGlowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: 38,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF922B).withOpacity(0.35 * _glowAnimation.value),
                blurRadius: 18 * _glowAnimation.value,
                spreadRadius: 6 * _glowAnimation.value,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Flame
              Transform.scale(
                scale: 0.9 + (0.2 * _glowAnimation.value),
                child: const Text('🔥', style: TextStyle(fontSize: 22)),
              ),
              // Wall Sconce Mount
              Container(
                width: 12,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A3420),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF2E1C0C), width: 1.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
