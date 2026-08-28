import 'package:flutter/material.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/models/labyrinth_chamber.dart';
import 'torch_glow_widget.dart';
import 'wooden_door_widget.dart';

class ChamberContentView extends StatelessWidget {
  final LabyrinthChamber chamber;
  final int? selectedCorrectDoor;
  final int? selectedWrongDoor;
  final ValueChanged<int>? onDoorTapped;
  final Widget? hallwayPreview;

  const ChamberContentView({
    super.key,
    required this.chamber,
    this.selectedCorrectDoor,
    this.selectedWrongDoor,
    this.onDoorTapped,
    this.hallwayPreview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── HERO EQUATION PLAQUE ─────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFEECC), Color(0xFFFFD899)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFD49A55),
                width: 3.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8A5A2B).withOpacity(0.2),
                  offset: const Offset(0, 6),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF382312),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF25160A),
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFFFF4DF),
                        offset: Offset(0, 1),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    '${chamber.equation} = ?',
                    style: AppTextStyles.numberTile.copyWith(
                      fontSize: 34,
                      letterSpacing: 2.0,
                      color: const Color(0xFFFFD43B),
                      shadows: [
                        const Shadow(
                          color: Color(0xFF9A5B00),
                          offset: Offset(0, 3),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        // ── CHAMBER DOORS & TORCHES ──────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Left Torch
              const Positioned(
                left: 0,
                top: 10,
                child: TorchGlowWidget(),
              ),

              // Right Torch
              const Positioned(
                right: 0,
                top: 10,
                child: TorchGlowWidget(),
              ),

              // Doors Row
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: chamber.doorOptions.map((doorVal) {
                    final isCorrect = selectedCorrectDoor == doorVal;
                    final isWrong = selectedWrongDoor == doorVal;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: WoodenDoorWidget(
                        doorValue: doorVal,
                        isCorrect: isCorrect,
                        isWrong: isWrong,
                        hallwayContent: isCorrect ? hallwayPreview : null,
                        onTap: () {
                          if (onDoorTapped != null) {
                            onDoorTapped!(doorVal);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
