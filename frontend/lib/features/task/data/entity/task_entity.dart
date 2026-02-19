import 'package:equatable/equatable.dart';

/// Domain entity for a single task.
class TaskEntity extends Equatable {
  const TaskEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.userId,
    required this.createdAt,
  });

  final String id;
  final String title;
  final bool status;
  final String priority;
  final DateTime? dueDate;
  final String userId;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, title, status, priority, dueDate, userId, createdAt];
}
