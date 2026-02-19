import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_typography.dart';

/// One row of filter pills: All (no filter), Pending, Completed, Low, Medium, High. Single selection.
class TaskFilterPills extends StatelessWidget {
  const TaskFilterPills({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const List<String> _labels = [
    'All',
    'Pending',
    'Completed',
    'Low',
    'Medium',
    'High',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingHorizontal,
        ),
        itemCount: _labels.length,
        separatorBuilder: (_, __) => SizedBox(width: AppDimensions.spacingS),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingL,
                vertical: AppDimensions.spacingS,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.inputBackground,
                borderRadius: AppDimensions.borderRadiusCircular,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: AppDimensions.borderWidthThin,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                _labels[index],
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Map (statusFilter, priorityFilter) to the single pill index 0..5.
class TaskFilterPillsHelper {
  static int selectedIndexFromFilters(
    bool? statusFilter,
    String? priorityFilter,
  ) {
    if (statusFilter == null && priorityFilter == null) return 0;
    if (statusFilter == false) return 1;
    if (statusFilter == true) return 2;
    if (priorityFilter == 'LOW') return 3;
    if (priorityFilter == 'MEDIUM') return 4;
    if (priorityFilter == 'HIGH') return 5;
    return 0;
  }
}
