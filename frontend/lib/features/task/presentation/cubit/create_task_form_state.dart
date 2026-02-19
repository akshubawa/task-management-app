import 'package:equatable/equatable.dart';

class CreateTaskFormState extends Equatable {
  const CreateTaskFormState({
    this.title = '',
    this.dueDate,
    this.priority = 'HIGH',
    this.taskId,
    this.isSubmitting = false,
    this.error,
  });

  final String title;
  final DateTime? dueDate;
  final String priority;
  final String? taskId;
  final bool isSubmitting;
  final String? error;

  bool get isEditMode => taskId != null;

  CreateTaskFormState copyWith({
    String? title,
    DateTime? dueDate,
    String? priority,
    String? taskId,
    bool? isSubmitting,
    String? error,
  }) {
    return CreateTaskFormState(
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      taskId: taskId ?? this.taskId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  @override
  List<Object?> get props => [title, dueDate, priority, taskId, isSubmitting, error];
}
