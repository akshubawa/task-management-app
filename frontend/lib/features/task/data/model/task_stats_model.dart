import 'package:task_management/features/task/data/entity/task_stats_entity.dart';

class TaskStatsModel {
  TaskStatsModel({
    required this.totalTasks,
    required this.totalCompletedTasks,
    required this.totalPendingTasks,
  });

  final int totalTasks;
  final int totalCompletedTasks;
  final int totalPendingTasks;

  factory TaskStatsModel.fromJson(Map<String, dynamic> json) {
    return TaskStatsModel(
      totalTasks: json['totalTasks'] as int? ?? 0,
      totalCompletedTasks: json['totalCompletedTasks'] as int? ?? 0,
      totalPendingTasks: json['totalPendingTasks'] as int? ?? 0,
    );
  }

  TaskStatsEntity toEntity() => TaskStatsEntity(
    totalTasks: totalTasks,
    totalCompletedTasks: totalCompletedTasks,
    totalPendingTasks: totalPendingTasks,
  );
}
