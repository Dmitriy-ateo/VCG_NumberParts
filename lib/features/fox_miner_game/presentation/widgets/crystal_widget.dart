import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../app/theme/app_text_styles.dart';

class CrystalWidget extends StatefulWidget {
  final int levelNumber;
  final int targetNumber;
  final int remainingNumber;
  final int tensCollected;
  final int singlesCollected;
  final bool isMissed;
  final VoidCallback? onHit;

  const CrystalWidget({
    super.key,
    required this.levelNumber,
    required this.targetNumber,
    required this.remainingNumber,
    required this.tensCollected,
    required this.singlesCollected,
    this.isMissed = false,
    this.onHit,
  });

  @override
  State<CrystalWidget> createState() => _CrystalWidgetState();
}

class _CrystalWidgetState extends State<CrystalWidget>
    with TickerProviderStateMixin {
  late AnimationController _hitController;
  late Animation<double> _hitScaleAnimation;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _hitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _hitScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.93), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 0.93, end: 1.05), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _hitController, curve: Curves.easeOut));

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -8.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 6.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 15),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.linear));
  }

  @override
  void didUpdateWidget(covariant CrystalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remainingNumber != oldWidget.remainingNumber) {
      _hitController.forward(from: 0.0);
    }
    if (widget.isMissed && !oldWidget.isMissed) {
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _hitController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  bool get _isBrokenIntoHeap =>
      widget.tensCollected > 0 || widget.singlesCollected > 0;

  int get _remainingTens => widget.remainingNumber ~/ 10;
  int get _remainingSingles => widget.remainingNumber % 10;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_hitScaleAnimation, _shakeAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0.0),
          child: Transform.scale(
            scale: _hitScaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 300,
            height: 220,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              child: _isBrokenIntoHeap
                  ? _buildCrystalHeap()
                  : _buildWholeCrystal(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWholeCrystal() {
    final wholeVariant = ((widget.levelNumber - 1) % 5) + 1;
    final rotation = (((widget.levelNumber * 37) % 25) - 12) * pi / 180;

    return Stack(
      key: const ValueKey('whole_crystal'),
      alignment: Alignment.center,
      children: [
        // Rotated Whole Crystal Image
        Transform.rotate(
          angle: rotation,
          child: Image.asset(
            'assets/images/crystals/crystal_whole_$wholeVariant.png',
            width: 220,
            height: 220,
            fit: BoxFit.contain,
          ),
        ),

        // Big floating number on the whole crystal
        Text(
          '${widget.remainingNumber}',
          style: AppTextStyles.numberTile.copyWith(
            fontSize: 48,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.85),
                offset: const Offset(0, 3),
                blurRadius: 8,
              ),
              const Shadow(
                color: Color(0xFF2B114F),
                offset: Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCrystalHeap() {
    final tens = _remainingTens;
    final singles = _remainingSingles;

    if (widget.remainingNumber == 0) {
      return const Center(
        key: ValueKey('empty_heap'),
        child: SizedBox.shrink(),
      );
    }

    return Column(
      key: const ValueKey('crystal_heap'),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // One cohesive heap of big & small crystals
        SizedBox(
          width: 260,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Big Crystals (Tens) clustered in the pile (no numbers on them)
              for (int i = 0; i < tens; i++) ...[
                Transform.translate(
                  offset: _getTensPileOffset(i, tens),
                  child: Transform.rotate(
                    angle: _getTensRotation(i),
                    child: Image.asset(
                      'assets/images/crystals/crystal_big_${(i % 5) + 1}.png',
                      width: tens > 5 ? 56 : 64,
                      height: tens > 5 ? 56 : 64,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],

              // Small Crystals (Singles) nestled in the heap
              for (int i = 0; i < singles; i++) ...[
                Transform.translate(
                  offset: _getSinglesPileOffset(i, singles, tens > 0),
                  child: Transform.rotate(
                    angle: _getSinglesRotation(i),
                    child: Image.asset(
                      'assets/images/crystals/crystal_small_${(i % 5) + 1}.png',
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Big number positioned cleanly below the heap
        Text(
          '${widget.remainingNumber}',
          style: AppTextStyles.numberTile.copyWith(
            fontSize: 44,
            color: const Color(0xFF38281E),
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: Colors.white.withValues(alpha: 0.95),
                offset: const Offset(0, 2),
                blurRadius: 3,
              ),
              Shadow(
                color: const Color(0xFF38281E).withValues(alpha: 0.2),
                offset: const Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Offset _getTensPileOffset(int index, int total) {
    if (total == 1) return Offset.zero;
    if (total == 2) {
      return index == 0 ? const Offset(-24, 0) : const Offset(24, 0);
    }
    if (total == 3) {
      return [
        const Offset(-24, 8),
        const Offset(24, 8),
        const Offset(0, -18),
      ][index];
    }
    if (total == 4) {
      return [
        const Offset(-26, -12),
        const Offset(26, -12),
        const Offset(-22, 14),
        const Offset(22, 14),
      ][index];
    }
    // 5 to 9: organic pile layout with crystals clustered together
    const pileOffsets = [
      Offset(-22, -14),
      Offset(22, -16),
      Offset(0, 8),
      Offset(-38, 4),
      Offset(38, 6),
      Offset(-12, -36),
      Offset(16, -34),
      Offset(-34, -20),
      Offset(34, -18),
    ];
    return pileOffsets[index % pileOffsets.length];
  }

  Offset _getSinglesPileOffset(int index, int total, bool hasTens) {
    if (!hasTens) {
      if (total == 1) return Offset.zero;
      if (total == 2) {
        return index == 0 ? const Offset(-18, 0) : const Offset(18, 0);
      }
      if (total == 3) {
        return [
          const Offset(-20, 8),
          const Offset(20, 8),
          const Offset(0, -14),
        ][index];
      }
      const cluster = [
        Offset(0, 0),
        Offset(-22, -12),
        Offset(22, -10),
        Offset(-18, 16),
        Offset(18, 14),
        Offset(0, -26),
        Offset(-34, 4),
        Offset(34, 2),
        Offset(0, 28),
      ];
      return cluster[index % cluster.length];
    }

    // When tens exist, singles sit nestled at the front base of the heap
    final double spacing = total > 5 ? 20.0 : 26.0;
    final double startX = -((total - 1) * spacing) / 2;
    final double x = startX + index * spacing;
    final double y = 35.0 + (index % 2 == 1 ? 5.0 : 0.0);
    return Offset(x, y);
  }

  double _getTensRotation(int index) {
    return (((index + 1) * 31) % 25 - 12) * pi / 180;
  }

  double _getSinglesRotation(int index) {
    return (((index + 1) * 23) % 21 - 10) * pi / 180;
  }
}
