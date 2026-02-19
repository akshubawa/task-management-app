import 'package:task_management/features/task/data/datasource/task_remote_data_source.dart';
import 'package:task_management/features/task/data/entity/task_entity.dart';
import 'package:task_management/features/task/data/model/create_task_body.dart';
import 'package:task_management/features/task/domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._remote);

  final TaskRemoteDataSource _remote;

  @override
  Future<TaskListResult> getTasks({
    required int page,
    required int limit,
    bool? status,
    String? priority,
    String? search,
  }) {
    return _remote.getTasks(
      page: page,
      limit: limit,
      status: status,
      priority: priority,
      search: search,
    );
  }

  @override
  Future<TaskEntity> createTask(CreateTaskBody body) {
    return _remote.createTask(body);
  }

  @override
  Future<TaskEntity> updateTask(String id, Map<String, dynamic> body) {
    return _remote.updateTask(id, body);
  }

  @override
  Future<void> deleteTask(String id) {
    return _remote.deleteTask(id);
  }

  @override
  Future<TaskEntity> toggleTask(String id) {
    return _remote.toggleTask(id);
  }
}
