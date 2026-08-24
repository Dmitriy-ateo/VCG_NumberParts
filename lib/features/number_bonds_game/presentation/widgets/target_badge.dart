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

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 12, 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF7E6),
            Color(0xFFFFE8B3),
            Color(0xFFFFD480),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD49B5A),
          width: 2.0,
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
        children: [
          Text(
            '${l10n.targetSumDisplay}:',
            style: AppTextStyles.titleSmall.copyWith(
              color: const Color(0xFF6B3A16),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6B3A16),
                  Color(0xFF4A250B),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD49B5A), width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 1.5),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Text(
              displayText,
              style: GoogleFonts.fredoka(
                color: const Color(0xFFFFD166),
                fontSize: targetEquation != null ? 18 : 20,
                fontWeight: FontWeight.w700,
                shadows: const [
                  Shadow(
                    color: Color(0xFFB88517),
                    offset: Offset(0.8, 1.2),
                    blurRadius: 0.5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
