import 'package:task_management/features/task/data/model/task_model.dart';

/// API response model for create/update/toggle (single task in data).
class TaskResponseModel {
  TaskResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  final bool status;
  final String message;
  final TaskModel? data;

  factory TaskResponseModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>?;
    return TaskResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: dataJson != null ? TaskModel.fromJson(dataJson) : null,
    );
  }
}
