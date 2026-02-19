import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_management/features/task/data/entity/task_entity.dart';
import 'package:task_management/features/task/data/model/create_task_body.dart';
import 'package:task_management/features/task/presentation/cubit/create_task_form_state.dart';
import 'package:task_management/features/task/presentation/cubit/task_cubit.dart';
import 'package:toastification/toastification.dart';

class CreateTaskFormCubit extends Cubit<CreateTaskFormState> {
  CreateTaskFormCubit({
    required this.taskCubit,
    TaskEntity? editTask,
  }) : super(editTask != null
            ? CreateTaskFormState(
                title: editTask.title,
                dueDate: editTask.dueDate,
                priority: editTask.priority,
                taskId: editTask.id,
              )
            : const CreateTaskFormState());

  final TaskCubit taskCubit;

  void setTitle(String value) => emit(state.copyWith(title: value));
  void setDueDate(DateTime? value) => emit(state.copyWith(dueDate: value));
  void setPriority(String value) => emit(state.copyWith(priority: value));

  /// Format due date for API: MM-DD-YYYY
  String? get dueDateApiFormat {
    if (state.dueDate == null) return null;
    return DateFormat('MM-dd-yyyy').format(state.dueDate!);
  }

  /// Submit create or update. [context] is used for Navigator.pop and showing toasts.
  Future<void> submit(BuildContext context) async {
    final title = state.title.trim();
    if (title.isEmpty) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        title: const Text('Please enter a task title'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      if (state.isEditMode && state.taskId != null) {
        final body = <String, dynamic>{
          'title': title,
          'priority': state.priority,
        };
        if (dueDateApiFormat != null) body['dueDate'] = dueDateApiFormat;
        await taskCubit.updateTask(state.taskId!, body);
      } else {
        final body = CreateTaskBody(
          title: title,
          priority: state.priority,
          dueDate: dueDateApiFormat,
        );
        await taskCubit.createTask(body);
      }
      if (context.mounted) Navigator.of(context).pop(true);
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void reset() => emit(const CreateTaskFormState());
}
