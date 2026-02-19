import 'package:task_management/features/task/data/entity/task_entity.dart';
import 'package:task_management/features/task/data/entity/task_pagination_entity.dart';
import 'package:task_management/features/task/data/entity/task_stats_entity.dart';
import 'package:task_management/features/task/data/model/create_task_body.dart';

/// Result of fetching a paginated task list.
class TaskListResult {
  TaskListResult({required this.tasks, required this.pagination, required this.stats});

  final List<TaskEntity> tasks;
  final TaskPaginationEntity pagination;
  final TaskStatsEntity stats;
}

abstract class TaskRemoteDataSource {
  Future<TaskListResult> getTasks({
    required int page,
    required int limit,
    bool? status,
    String? priority,
    String? search,
  });

  Future<TaskEntity> createTask(CreateTaskBody body);

  Future<TaskEntity> updateTask(String id, Map<String, dynamic> body);

  Future<void> deleteTask(String id);

  Future<TaskEntity> toggleTask(String id);
}
