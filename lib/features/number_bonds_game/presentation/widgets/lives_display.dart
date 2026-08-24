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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            padding: EdgeInsets.only(left: index == 0 ? 0 : 4),
            child: AnimatedScale(
              scale: isAlive ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                opacity: isAlive ? 1.0 : 0.35,
                duration: const Duration(milliseconds: 250),
                child: Text(
                  isAlive ? '❤️' : '🤍',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
