import 'package:equatable/equatable.dart';

/// Domain entity for pagination metadata.
class TaskStatsEntity extends Equatable {
  const TaskStatsEntity({
    required this.totalTasks,
    required this.totalCompletedTasks,
    required this.totalPendingTasks,
  });

  final int totalTasks;
  final int totalCompletedTasks;
  final int totalPendingTasks;
  @override
  List<Object?> get props => [totalTasks, totalCompletedTasks, totalPendingTasks];
}
