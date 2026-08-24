import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';

class TargetBadge extends StatelessWidget {
  final int targetSum;

  const TargetBadge({
    super.key,
    required this.targetSum,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context).strings;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.pastelYellow.withAlpha(150),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.pastelYellowDark,
          width: 2.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowWarm,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${l10n.targetSumDisplay}:',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$targetSum',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.pastelYellow,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
