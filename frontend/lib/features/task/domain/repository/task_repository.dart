import 'package:task_management/features/task/data/datasource/task_remote_data_source.dart';
import 'package:task_management/features/task/data/entity/task_entity.dart';
import 'package:task_management/features/task/data/model/create_task_body.dart';

abstract class TaskRepository {
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
