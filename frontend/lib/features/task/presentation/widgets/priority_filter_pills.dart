import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_typography.dart';

/// Priority filter pills: All, Low, Medium, High. Uses API enums: LOW, MEDIUM, HIGH.
class PriorityFilterPills extends StatelessWidget {
  const PriorityFilterPills({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  /// 0 = All, 1 = Low, 2 = Medium, 3 = High.
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const List<String> _labels = ['All', 'Low', 'Medium', 'High'];

  /// Map pill index to API priority value (null = All).
  static String? priorityFromIndex(int index) {
    if (index <= 0) return null;
    if (index == 1) return 'LOW';
    if (index == 2) return 'MEDIUM';
    if (index == 3) return 'HIGH';
    return null;
  }

  static int indexFromPriority(String? priority) {
    if (priority == null) return 0;
    if (priority == 'LOW') return 1;
    if (priority == 'MEDIUM') return 2;
    if (priority == 'HIGH') return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingHorizontal),
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
                color: isSelected ? AppColors.primary : AppColors.inputBackground,
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
