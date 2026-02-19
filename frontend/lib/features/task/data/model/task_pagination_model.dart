import 'package:task_management/features/task/data/entity/task_pagination_entity.dart';

/// API model for pagination in task list response.
class TaskPaginationModel {
  TaskPaginationModel({
    required this.totalRecords,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int limit;
  final bool hasNextPage;
  final bool hasPreviousPage;

  factory TaskPaginationModel.fromJson(Map<String, dynamic> json) {
    return TaskPaginationModel(
      totalRecords: json['totalRecords'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }

  TaskPaginationEntity toEntity() => TaskPaginationEntity(
        totalRecords: totalRecords,
        totalPages: totalPages,
        currentPage: currentPage,
        limit: limit,
        hasNextPage: hasNextPage,
        hasPreviousPage: hasPreviousPage,
      );
}
