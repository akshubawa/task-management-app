import 'package:task_management/features/task/data/model/task_model.dart';
import 'package:task_management/features/task/data/model/task_pagination_model.dart';
import 'package:task_management/features/task/data/model/task_stats_model.dart';

/// API response model for GET /tasks (paginated list).
class TaskListResponseModel {
  TaskListResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final TaskListDataModel data;

  factory TaskListResponseModel.fromJson(Map<String, dynamic> json) {
    return TaskListResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: TaskListDataModel.fromJson(
        (json['data'] as Map<String, dynamic>? ?? {}),
      ),
    );
  }
}

class TaskListDataModel {
  TaskListDataModel({
    required this.tasks,
    required this.pagination,
    required this.stats,
  });

  final List<TaskModel> tasks;
  final TaskPaginationModel pagination;
  final TaskStatsModel stats;

  factory TaskListDataModel.fromJson(Map<String, dynamic> json) {
    final tasksList = json['tasks'] as List<dynamic>? ?? [];
    return TaskListDataModel(
      tasks: tasksList
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: TaskStatsModel.fromJson(
        (json['stats'] as Map<String, dynamic>? ?? {}),
      ),
      pagination: TaskPaginationModel.fromJson(
        (json['pagination'] as Map<String, dynamic>? ?? {}),
      ),
    );
  }
}
