import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? shadowColor;
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final double bevelHeight;

  const BouncyButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.shadowColor,
    this.height = 56,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.borderRadius,
    this.bevelHeight = 5.0,
  });

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? AppColors.pastelPeach;
    final shadow = widget.shadowColor ?? AppColors.pastelPeachDark;
    final radius = widget.borderRadius ?? BorderRadius.circular(20);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOutQuad,
        margin: EdgeInsets.only(
          top: _isPressed ? widget.bevelHeight : 0,
          bottom: _isPressed ? 0 : widget.bevelHeight,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: shadow,
                    offset: Offset(0, widget.bevelHeight),
                    blurRadius: 0,
                  ),
                  const BoxShadow(
                    color: AppColors.shadowWarm,
                    offset: Offset(0, 8),
                    blurRadius: 10,
                  ),
                ],
        ),
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}
