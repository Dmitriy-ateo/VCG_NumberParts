import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';

class TargetBadge extends StatelessWidget {
  final int targetSum;
  final String? targetEquation;

  const TargetBadge({
    super.key,
    required this.targetSum,
    this.targetEquation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context).strings;
    final displayText = targetEquation ?? '$targetSum';
    final isEquation = targetEquation != null;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF9EE),
              Color(0xFFFFE8B3),
              Color(0xFFFFD480),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFD49B5A),
            width: 2.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x356B3A16),
              offset: Offset(0, 5),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Target Label
            Text(
              '${l10n.targetSumDisplay.toUpperCase()}:',
              style: GoogleFonts.fredoka(
                color: const Color(0xFF7A3E12),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 12),

            // Inset Dark Wood & Clay Target Plate
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isEquation ? 16 : 14,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF5E3211),
                    Color(0xFF3F1D06),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD49B5A),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Text(
                displayText,
                style: GoogleFonts.fredoka(
                  color: const Color(0xFFFFD166),
                  fontSize: isEquation ? 26 : 30,
                  fontWeight: FontWeight.w700,
                  shadows: const [
                    Shadow(
                      color: Color(0xFFB88517),
                      offset: Offset(1.0, 1.5),
                      blurRadius: 1.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
