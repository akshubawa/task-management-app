import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_typography.dart';
import 'package:task_management/features/task/data/entity/task_entity.dart';

/// Priority level for task chip styling.
enum TaskPriority { low, medium, high }

/// Stateless single task row for the dashboard list.
class TaskListItem extends StatelessWidget {
  const TaskListItem({
    super.key,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.isCompleted = false,
    this.onToggle,
    this.onDelete,
    this.onEdit,
  });

  final String title;
  final String? description;
  final String? dueDate;
  final TaskPriority priority;
  final bool isCompleted;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  /// Build from [TaskEntity] with optional actions.
  factory TaskListItem.fromEntity({
    required TaskEntity task,
    VoidCallback? onToggle,
    VoidCallback? onDelete,
    VoidCallback? onEdit,
  }) {
    return TaskListItem(
      title: task.title,
      description: null,
      dueDate: task.dueDate != null
          ? DateFormat.MMMd().format(task.dueDate!)
          : null,
      priority: _priorityFromString(task.priority),
      isCompleted: task.status,
      onToggle: onToggle,
      onDelete: onDelete,
      onEdit: onEdit,
    );
  }

  static TaskPriority _priorityFromString(String p) {
    switch (p.toUpperCase()) {
      case 'HIGH':
        return TaskPriority.high;
      case 'LOW':
        return TaskPriority.low;
      default:
        return TaskPriority.medium;
    }
  }

  static Color _priorityColor(TaskPriority p) {
    switch (p) {
      case TaskPriority.low:
        return AppColors.success;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.high:
        return AppColors.error;
    }
  }

  static String _priorityLabel(TaskPriority p) {
    switch (p) {
      case TaskPriority.low:
        return 'LOW';
      case TaskPriority.medium:
        return 'MEDIUM';
      case TaskPriority.high:
        return 'HIGH';
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _priorityColor(priority);
    return Opacity(
      opacity: isCompleted ? 0.65 : 1.0,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingHorizontal,
        ),
        padding: AppDimensions.listItemPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppDimensions.borderRadiusM,
          border: Border.all(
            color: AppColors.border,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onToggle,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 24.w,
                height: 24.h,
                child: isCompleted
                    ? Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 24.r,
                      )
                    : Icon(
                        Icons.radio_button_unchecked,
                        color: AppColors.iconSecondary,
                        size: 24.r,
                      ),
              ),
            ),
            SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTypography.bodyMediumMedium.copyWith(
                            color: AppColors.textPrimary,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingS,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: priorityColor,
                          borderRadius: AppDimensions.borderRadiusXs,
                        ),
                        child: Text(
                          _priorityLabel(priority),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (dueDate != null && dueDate!.isNotEmpty) ...[
                    SizedBox(height: AppDimensions.spacingS),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: AppDimensions.iconXs,
                          color: AppColors.iconTertiary,
                        ),
                        SizedBox(width: AppDimensions.spacingXs),
                        // show due date in India's time so had to a
                        Text(
                          dueDate!,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (onEdit != null || onDelete != null)
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  size: 20.r,
                  color: AppColors.iconSecondary,
                ),
                onSelected: (value) {
                  if (value == 'edit') onEdit?.call();
                  if (value == 'delete') onDelete?.call();
                },
                itemBuilder: (context) => [
                  if (onEdit != null)
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  if (onDelete != null)
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
