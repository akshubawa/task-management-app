import 'package:dio/dio.dart' show Response;
import 'package:task_management/core/constants/endpoints.dart';
import 'package:task_management/core/services/api_service.dart';
import 'package:task_management/features/task/data/datasource/task_remote_data_source.dart';
import 'package:task_management/features/task/data/entity/task_entity.dart';
import 'package:task_management/features/task/data/model/create_task_body.dart';
import 'package:task_management/features/task/data/model/task_list_response_model.dart';
import 'package:task_management/features/task/data/model/task_response_model.dart';

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  TaskRemoteDataSourceImpl(this._api);

  final ApiService _api;

  @override
  Future<TaskListResult> getTasks({
    required int page,
    required int limit,
    bool? status,
    String? priority,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};
      if (status != null) queryParams['status'] = status;
      if (priority != null) queryParams['priority'] = priority;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      final response = await _api.get(
        Endpoints.tasks,
        queryParameters: queryParams,
      );
      _validateStatus(response);
      final model = TaskListResponseModel.fromJson(_responseData(response));
      if (!model.status) {
        throw Exception(
          model.message.isNotEmpty ? model.message : 'Failed to fetch tasks',
        );
      }
      return TaskListResult(
        tasks: model.data.tasks.map((e) => e.toEntity()).toList(),
        pagination: model.data.pagination.toEntity(),
        stats: model.data.stats.toEntity(),
      );
    } catch (e) {
      throw Exception(_messageFromError(e));
    }
  }

  @override
  Future<TaskEntity> createTask(CreateTaskBody body) async {
    try {
      final response = await _api.post(Endpoints.tasks, data: body.toJson());
      _validateStatus(response);
      final model = TaskResponseModel.fromJson(_responseData(response));
      if (!model.status || model.data == null) {
        throw Exception(
          model.message.isNotEmpty ? model.message : 'Failed to create task',
        );
      }
      return model.data!.toEntity();
    } catch (e) {
      throw Exception(_messageFromError(e));
    }
  }

  @override
  Future<TaskEntity> updateTask(String id, Map<String, dynamic> body) async {
    try {
      final response = await _api.patch(Endpoints.taskById(id), data: body);
      _validateStatus(response);
      final model = TaskResponseModel.fromJson(_responseData(response));
      if (!model.status || model.data == null) {
        throw Exception(
          model.message.isNotEmpty ? model.message : 'Failed to update task',
        );
      }
      return model.data!.toEntity();
    } catch (e) {
      throw Exception(_messageFromError(e));
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final response = await _api.delete(Endpoints.taskById(id));
      _validateStatus(response);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final status = data['status'] as bool? ?? false;
        if (!status) {
          final message = data['message'] as String? ?? 'Failed to delete task';
          throw Exception(message);
        }
      }
    } catch (e) {
      throw Exception(_messageFromError(e));
    }
  }

  @override
  Future<TaskEntity> toggleTask(String id) async {
    try {
      final response = await _api.patch(Endpoints.taskToggle(id));
      _validateStatus(response);
      final model = TaskResponseModel.fromJson(_responseData(response));
      if (!model.status || model.data == null) {
        throw Exception(
          model.message.isNotEmpty ? model.message : 'Failed to toggle task',
        );
      }
      return model.data!.toEntity();
    } catch (e) {
      throw Exception(_messageFromError(e));
    }
  }

  Map<String, dynamic> _responseData(Response response) {
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }
    return data;
  }

  void _validateStatus(Response response) {
    final code = response.statusCode ?? 0;
    if (code >= 200 && code < 300) return;
    final data = response.data;
    String? message;
    if (data is Map<String, dynamic>) {
      message = data['message'] as String?;
    }
    throw Exception(message ?? 'Request failed with status $code');
  }

  String _messageFromError(dynamic e) {
    if (e is String && e.isNotEmpty) return e;
    if (e is Exception) return e.toString().replaceFirst('Exception: ', '');
    return 'Something went wrong. Please try again.';
  }
}
