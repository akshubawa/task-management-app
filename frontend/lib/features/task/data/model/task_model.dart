import 'package:task_management/features/task/data/entity/task_entity.dart';

/// API model for a single task.
class TaskModel {
  TaskModel({
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

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final dueDateRaw = json['dueDate'];
    DateTime? dueDate;
    if (dueDateRaw != null && dueDateRaw is String) {
      dueDate = DateTime.tryParse(dueDateRaw);
    }
    final createdAtRaw = json['createdAt'];
    DateTime createdAt = DateTime.now();
    if (createdAtRaw != null && createdAtRaw is String) {
      createdAt = DateTime.tryParse(createdAtRaw) ?? createdAt;
    }
    return TaskModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as bool? ?? false,
      priority: json['priority'] as String? ?? 'MEDIUM',
      dueDate: dueDate,
      userId: json['userId'] as String? ?? '',
      createdAt: createdAt,
    );
  }

  TaskEntity toEntity() => TaskEntity(
        id: id,
        title: title,
        status: status,
        priority: priority,
        dueDate: dueDate,
        userId: userId,
        createdAt: createdAt,
      );
}
