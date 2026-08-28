import 'package:flutter/material.dart';
import 'package:number_parts/app/theme/app_text_styles.dart';
import 'package:number_parts/features/trampoline_game/domain/models/trampoline_data.dart';

class SpringTrampolineWidget extends StatelessWidget {
  final TrampolineData trampoline;
  final bool isSelected;
  final bool isSquashing;
  final VoidCallback onTap;

  const SpringTrampolineWidget({
    super.key,
    required this.trampoline,
    this.isSelected = false,
    this.isSquashing = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 106,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── TRAMPOLINE BED & SPRINGS ─────────────────────────────
            SizedBox(
              height: 52,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Wooden Legs & Base Frame
                  Positioned(
                    bottom: 0,
                    left: 6,
                    right: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLeg(),
                        _buildLeg(),
                      ],
                    ),
                  ),

                  // Metallic Coiled Springs
                  Positioned(
                    bottom: 12,
                    left: 2,
                    right: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSpring(),
                        _buildSpring(),
                      ],
                    ),
                  ),

                  // Elastic Bouncy Mat (Flexes down when squashed)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOutBack,
                    top: isSquashing ? 18 : 6,
                    left: 8,
                    right: 8,
                    child: Container(
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF20C997), Color(0xFF0CA678)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF087F5B),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF087F5B).withOpacity(0.4),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                          if (isSelected)
                            BoxShadow(
                              color: const Color(0xFFFFD43B).withOpacity(0.8),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '⚡',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // ── WOODEN EQUATION PLAQUE ───────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                  width: isSelected ? 3.0 : 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8A5A2B).withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                trampoline.expression,
                style: AppTextStyles.numberTile.copyWith(
                  fontSize: 18,
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

  Widget _buildLeg() {
    return Container(
      width: 10,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF8A5A2B),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF5A3611), width: 1.5),
      ),
    );
  }

  Widget _buildSpring() {
    return Container(
      width: 16,
      height: 12,
      decoration: BoxDecoration(
        color: const Color(0xFFCED4DA),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF868E96), width: 1.5),
      ),
      child: const Center(
        child: Text('§', style: TextStyle(fontSize: 10, color: Color(0xFF495057), fontWeight: FontWeight.bold)),
      ),
    );
  }
}
