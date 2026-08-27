import 'package:flutter/material.dart';
import '../../../../app/theme/app_text_styles.dart';

class ChamberStepperBar extends StatelessWidget {
  final int currentIndex;
  final int totalChambers;

  const ChamberStepperBar({
    super.key,
    required this.currentIndex,
    required this.totalChambers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE2C9A5),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A5A2B).withOpacity(0.12),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int i = 0; i < totalChambers; i++) ...[
            _buildStepNode(i),
            if (i < totalChambers - 1)
              Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: i < currentIndex
                        ? const Color(0xFF51CF66)
                        : const Color(0xFFDEE2E6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
          ],
          const SizedBox(width: 8),
          // Treasure Chest Endpoint
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: currentIndex >= totalChambers - 1
                  ? const Color(0xFFFFD43B)
                  : const Color(0xFFE9ECEF),
              shape: BoxShape.circle,
              border: Border.all(
                color: currentIndex >= totalChambers - 1
                    ? const Color(0xFFF59F00)
                    : const Color(0xFFCED4DA),
                width: 2,
              ),
            ),
            child: const Text('🏆', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildStepNode(int index) {
    final isDone = index < currentIndex;
    final isCurrent = index == currentIndex;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCurrent ? 32 : 26,
      height: isCurrent ? 32 : 26,
      decoration: BoxDecoration(
        color: isDone
            ? const Color(0xFF51CF66)
            : isCurrent
                ? const Color(0xFFFF922B)
                : const Color(0xFFF1F3F5),
        shape: BoxShape.circle,
        border: Border.all(
          color: isDone
              ? const Color(0xFF2B8A3E)
              : isCurrent
                  ? const Color(0xFFD9480F)
                  : const Color(0xFFCED4DA),
          width: isCurrent ? 2.5 : 1.5,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: const Color(0xFFFF922B).withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: Center(
        child: isDone
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : Text(
                '${index + 1}',
                style: AppTextStyles.numberTile.copyWith(
                  fontSize: isCurrent ? 16 : 13,
                  color: isCurrent ? Colors.white : const Color(0xFF868E96),
                ),
              ),
      ),
    );
  }
}
