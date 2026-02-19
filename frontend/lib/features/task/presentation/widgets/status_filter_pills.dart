import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_typography.dart';

/// Status filter pills: All, Pending, Completed.
/// selectedIndex: 0 = All, 1 = Pending, 2 = Completed.
class StatusFilterPills extends StatelessWidget {
  const StatusFilterPills({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const List<String> _labels = ['All', 'Pending', 'Completed'];

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
