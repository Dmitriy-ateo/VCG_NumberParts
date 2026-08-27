import 'package:flutter/material.dart';
import '../../../../app/theme/app_text_styles.dart';

class WoodenDoorWidget extends StatefulWidget {
  final int doorValue;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const WoodenDoorWidget({
    super.key,
    required this.doorValue,
    this.isCorrect = false,
    this.isWrong = false,
    required this.onTap,
  });

  @override
  State<WoodenDoorWidget> createState() => _WoodenDoorWidgetState();
}

class _WoodenDoorWidgetState extends State<WoodenDoorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _openAnimation;
  late Animation<double> _wobbleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _openAnimation = Tween<double>(begin: 0.0, end: -0.7).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic),
    );

    _wobbleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.15, end: 0.15), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.15, end: -0.1), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.1), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: 0.0), weight: 1),
    ]).animate(_animController);
  }

  @override
  void didUpdateWidget(covariant WoodenDoorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCorrect && !oldWidget.isCorrect) {
      _animController.forward(from: 0.0);
    } else if (widget.isWrong && !oldWidget.isWrong) {
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        double rotationY = 0.0;
        double rotationZ = 0.0;

        if (widget.isCorrect) {
          rotationY = _openAnimation.value;
        } else if (widget.isWrong) {
          rotationZ = _wobbleAnimation.value;
        }

        return Transform(
          alignment: Alignment.centerLeft,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY(rotationY)
            ..rotateZ(rotationZ),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 96,
          height: 148,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(48),
              topRight: Radius.circular(48),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE2B77A),
                Color(0xFFBA8448),
                Color(0xFF8E5A23),
              ],
            ),
            border: Border.all(
              color: const Color(0xFF633A11),
              width: 3.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                offset: const Offset(0, 8),
                blurRadius: 12,
              ),
              const BoxShadow(
                color: Color(0xFFFFE0A3),
                offset: Offset(0, -2),
                blurRadius: 0,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Vertical Wooden Planks lines
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: const Color(0xFF633A11).withOpacity(0.35),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: const Color(0xFF633A11).withOpacity(0.35),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),

              // Iron Door Arch Trim
              Positioned(
                top: 8,
                child: Container(
                  width: 64,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    border: Border.all(
                      color: const Color(0xFF4A3420),
                      width: 2,
                    ),
                  ),
                ),
              ),

              // Number Plaque with 3D Depth
              Positioned(
                top: 42,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6E5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF8A5A2B),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5A3511).withOpacity(0.5),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    '${widget.doorValue}',
                    style: AppTextStyles.numberTile.copyWith(
                      fontSize: 30,
                      color: const Color(0xFFE8590C),
                      shadows: [
                        const Shadow(
                          color: Color(0xFF8E3B06),
                          offset: Offset(0, 2),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Golden Ring Door Knocker
              Positioned(
                bottom: 16,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFD43B),
                    border: Border.all(
                      color: const Color(0xFF8A5A2B),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 3,
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
