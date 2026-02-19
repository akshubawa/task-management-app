import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_typography.dart';
import 'package:task_management/core/utils/custom_button.dart';
import 'package:intl/intl.dart';

class CustomMonthPicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onMonthChanged;

  const CustomMonthPicker({
    super.key,
    required this.selectedDate,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDimensions.borderRadiusM,
        border: Border.all(
          color: AppColors.border,
          width: AppDimensions.borderWidthThin,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Month Button
          GestureDetector(
            onTap: () => _goToPreviousMonth(),
            child: Icon(
              Icons.chevron_left,
              color: AppColors.iconPrimary,
              size: AppDimensions.iconL,
            ),
          ),

          // Month and Year Display with Calendar Icon
          GestureDetector(
            onTap: () => _showMonthYearPicker(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: AppTypography.bodyMediumMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: AppDimensions.spacingS),
                Icon(
                  Icons.calendar_month,
                  color: AppColors.iconSecondary,
                  size: AppDimensions.iconM,
                ),
              ],
            ),
          ),

          // Next Month Button
          GestureDetector(
            onTap: () => _goToNextMonth(),
            child: Icon(
              Icons.chevron_right,
              color: AppColors.iconPrimary,
              size: AppDimensions.iconL,
            ),
          ),
        ],
      ),
    );
  }

  void _goToPreviousMonth() {
    final newDate = DateTime(
      selectedDate.year,
      selectedDate.month - 1,
      1,
    );
    onMonthChanged(newDate);
  }

  void _goToNextMonth() {
    // Don't allow going beyond current month
    final now = DateTime.now();
    final nextMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      1,
    );
    
    if (nextMonth.isBefore(DateTime(now.year, now.month + 1, 1))) {
      onMonthChanged(nextMonth);
    }
  }

  Future<void> _showMonthYearPicker(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return _MonthYearPickerDialog(
          initialDate: selectedDate,
        );
      },
    );

    if (picked != null) {
      onMonthChanged(picked);
    }
  }
}

class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;

  const _MonthYearPickerDialog({
    required this.initialDate,
  });

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final availableYears = List.generate(
      now.year - 2020 + 1,
      (index) => 2020 + index,
    ).reversed.toList();

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusL,
      ),
      child: Container(
        padding: AppDimensions.dialogPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Select Month & Year',
              style: AppTypography.h3,
            ),
            SizedBox(height: AppDimensions.spacing2Xl),

            // Year Selector
            Text(
              'Year',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppDimensions.spacingS),
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: AppDimensions.borderRadiusM,
                border: Border.all(
                  color: AppColors.border,
                  width: AppDimensions.borderWidthThin,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: selectedYear,
                  isExpanded: true,
                  dropdownColor: AppColors.surface,
                  style: AppTypography.inputText,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.iconSecondary,
                  ),
                  items: availableYears.map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(
                        year.toString(),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value!;
                      // Adjust month if current year and month is in future
                      if (selectedYear == now.year && selectedMonth > now.month) {
                        selectedMonth = now.month;
                      }
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: AppDimensions.spacingL),

            // Month Selector
            Text(
              'Month',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppDimensions.spacingS),
            _buildMonthGrid(now),
            SizedBox(height: AppDimensions.spacing2Xl),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTypography.buttonMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.spacingM),
                CustomButton(
                  text: 'Select',
                  onPressed: () {
                    Navigator.pop(
                      context,
                      DateTime(selectedYear, selectedMonth, 1),
                    );
                  },
                  sizeType: ButtonSizeType.small,
                  shapeType: ButtonShapeType.pill,
                  // Keep it compact for dialog actions.
                  customWidth: 90.w,
                  customHeight: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthGrid(DateTime now) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppDimensions.spacingS,
        mainAxisSpacing: AppDimensions.spacingS,
        childAspectRatio: 2.2,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final monthIndex = index + 1;
        final isSelected = monthIndex == selectedMonth;
        final isDisabled = selectedYear == now.year && monthIndex > now.month;

        return GestureDetector(
          onTap: isDisabled
              ? null
              : () {
                  setState(() {
                    selectedMonth = monthIndex;
                  });
                },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isDisabled
                      ? AppColors.surface
                      : AppColors.inputBackground,
              borderRadius: AppDimensions.borderRadiusS,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.border,
                width: AppDimensions.borderWidthThin,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              months[index],
              style: AppTypography.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.white
                    : isDisabled
                        ? AppColors.textDisabled
                        : AppColors.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}