import 'package:flutter/material.dart';
import 'package:number_parts/app/theme/app_text_styles.dart';
import 'package:number_parts/features/trampoline_game/domain/models/trampoline_data.dart';
import 'package:number_parts/features/trampoline_game/domain/models/trampoline_visual_state.dart';

class SpringTrampolineWidget extends StatelessWidget {
  final TrampolineData trampoline;
  final TrampolineVisualState visualState;
  final bool isSelected;
  final VoidCallback onTap;

  const SpringTrampolineWidget({
    super.key,
    required this.trampoline,
    this.visualState = TrampolineVisualState.idle,
    this.isSelected = false,
    required this.onTap,
  });

  String get _frameAssetPath {
    switch (visualState) {
      case TrampolineVisualState.idle:
        return 'assets/images/trampoline_idle.png';
      case TrampolineVisualState.touching:
        return 'assets/images/trampoline_touching.png';
      case TrampolineVisualState.releasing:
        return 'assets/images/trampoline_releasing.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── WIDE TRANSPARENT 3D TRAMPOLINE IMAGE ─────────────────
            Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD43B).withOpacity(0.75),
                            blurRadius: 18,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(
                  height: 76,
                  child: Image.asset(
                    _frameAssetPath,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // ── WOODEN EQUATION PLAQUE ───────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFEECC), Color(0xFFFFD899)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFE8590C)
                      : const Color(0xFFD49A55),
                  width: isSelected ? 3.0 : 2.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8A5A2B).withOpacity(0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                trampoline.expression,
                style: AppTextStyles.numberTile.copyWith(
                  fontSize: 17,
                  color: const Color(0xFF8A5A2B),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
