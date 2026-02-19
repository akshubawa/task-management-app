import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_typography.dart';

/// Stateless summary cards for Completed and Pending task counts.
class TaskSummaryCards extends StatelessWidget {
  const TaskSummaryCards({
    super.key,
    required this.completedCount,
    required this.pendingCount,
  });

  final int completedCount;
  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 100.h,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingHorizontal,
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.check_circle_outline,
                iconColor: AppColors.success,
                label: 'Completed',
                count: completedCount,

                changeColor: AppColors.success,
              ),
            ),
            SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: _SummaryCard(
                icon: Icons.schedule_outlined,
                iconColor: AppColors.iconActive,
                label: 'Pending',
                count: pendingCount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.count,

    this.changeColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final int count;

  final Color? changeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      padding: AppDimensions.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(
          color: AppColors.border,
          width: AppDimensions.borderWidthThin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: AppDimensions.iconL),
          SizedBox(height: AppDimensions.spacingS),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.spacingXs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$count',
                style: AppTypography.statNumberMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
