import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:intl/intl.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/constants/app_typography.dart';
import 'package:task_management/core/utils/custom_button.dart';
import 'package:task_management/core/utils/custom_textfield.dart';
import 'package:task_management/features/task/data/entity/task_entity.dart';
import 'package:task_management/features/task/presentation/cubit/create_task_form_cubit.dart';
import 'package:task_management/features/task/presentation/cubit/create_task_form_state.dart';
import 'package:task_management/features/task/presentation/cubit/task_cubit.dart';

/// Bottom sheet for creating or editing a task: title, due date, priority, Save/Update/Cancel.
class CreateTaskBottomSheet extends StatelessWidget {
  const CreateTaskBottomSheet({super.key, this.editTask});

  final TaskEntity? editTask;

  static const List<String> _priorities = ['HIGH', 'MEDIUM', 'LOW'];

  /// [taskCubit] must be provided. Pass [editTask] to open in edit mode with prefilled values.
  static Future<T?> show<T>(
    BuildContext context, {
    required TaskCubit taskCubit,
    TaskEntity? editTask,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider(
        create: (_) =>
            CreateTaskFormCubit(taskCubit: taskCubit, editTask: editTask),
        child: CreateTaskBottomSheet(editTask: editTask),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppDimensions.screenPaddingHorizontal,
        right: AppDimensions.screenPaddingHorizontal,
        top: AppDimensions.spacingL,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + AppDimensions.spacingL,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            SizedBox(height: AppDimensions.spacing2Xl),
            _buildForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isEdit = editTask != null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isEdit ? 'Edit Task' : 'Create New Task',
          style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: Icon(
                Icons.close,
                size: 20.r,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return BlocConsumer<CreateTaskFormCubit, CreateTaskFormState>(
      listenWhen: (a, b) => a.error != b.error,
      listener: (context, state) {
        if (state.error != null && state.error!.isNotEmpty) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            title: Text(state.error!),
            autoCloseDuration: const Duration(seconds: 3),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CreateTaskFormCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TaskTitleField(cubit: cubit, initialTitle: state.title),
            SizedBox(height: AppDimensions.spacingL),
            _DueDateRow(
              dueDate: state.dueDate,
              onTap: () => _pickDate(context, cubit, state),
            ),
            SizedBox(height: AppDimensions.spacingL),
            Text(
              'Priority',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppDimensions.spacingS),
            Row(
              children: _priorities.map((p) {
                final isSelected = state.priority == p;
                return Padding(
                  padding: EdgeInsets.only(right: AppDimensions.spacingS),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => cubit.setPriority(p),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingL,
                          vertical: AppDimensions.spacingS,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : AppColors.inputBackground,
                          borderRadius: AppDimensions.borderRadiusM,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          p,
                          style: AppTypography.labelMedium.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: AppDimensions.spacing2Xl),
            CustomButton(
              onPressed: state.isSubmitting
                  ? null
                  : () => cubit.submit(context),
              text: state.isEditMode ? 'Update Task' : 'Save Task',
              prefixIcon: Icon(Icons.check, color: AppColors.white, size: 20.r),
              backgroundColor: AppColors.primary,
              textColor: AppColors.white,
              sizeType: ButtonSizeType.large,
            ),
            SizedBox(height: AppDimensions.spacingM),
            Center(
              child: TextButton(
                onPressed: state.isSubmitting
                    ? null
                    : () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    CreateTaskFormCubit cubit,
    CreateTaskFormState state,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstDate = today;
    final lastDate = today.add(const Duration(days: 365 * 2));
    var initialDate = state.dueDate ?? today.add(const Duration(days: 1));
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;
    if (initialDate.isAfter(lastDate)) initialDate = lastDate;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (context.mounted && date != null) cubit.setDueDate(date);
  }
}

class _DueDateRow extends StatelessWidget {
  const _DueDateRow({required this.dueDate, required this.onTap});

  final DateTime? dueDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final displayText = _formatDueDate(dueDate);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimensions.borderRadiusM,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingL,
          ),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: AppDimensions.borderRadiusM,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: AppColors.primary,
                size: AppDimensions.iconM,
              ),
              SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DUE DATE',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      displayText,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14.r,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDueDate(DateTime? date) {
    if (date == null) return 'Select date';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    if (dateOnly == today) return 'Today';
    if (dateOnly == tomorrow) return 'Tomorrow';
    return DateFormat.MMMd().format(date);
  }
}

/// Holds a single [TextEditingController] for the title so it is not recreated on every build.
/// Fixes reverse-typing bug when controller was recreated with state.title each rebuild.
class _TaskTitleField extends StatefulWidget {
  const _TaskTitleField({required this.cubit, required this.initialTitle});

  final CreateTaskFormCubit cubit;
  final String initialTitle;

  @override
  State<_TaskTitleField> createState() => _TaskTitleFieldState();
}

class _TaskTitleFieldState extends State<_TaskTitleField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      labelText: 'Task Title',
      hintText: 'e.g. Review Q3 Design',
      fieldType: InputFieldType.text,
      fieldSize: InputFieldSize.medium,
      onChanged: widget.cubit.setTitle,
    );
  }
}
