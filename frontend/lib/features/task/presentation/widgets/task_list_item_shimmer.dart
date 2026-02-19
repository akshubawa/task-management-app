import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';

/// Shimmer placeholder for a single task list item. No loaders.
class TaskListItemShimmer extends StatelessWidget {
  const TaskListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.inputBackground,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingHorizontal),
        padding: AppDimensions.listItemPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppDimensions.borderRadiusM,
          border: Border.all(color: AppColors.border, width: AppDimensions.borderWidthThin),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingS),
                  Container(
                    height: 12.h,
                    width: 180.w,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingS),
                  Container(
                    height: 10.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
