import 'package:equatable/equatable.dart';
import 'package:task_management/features/task/data/entity/task_entity.dart';
import 'package:task_management/features/task/data/entity/task_pagination_entity.dart';
import 'package:task_management/features/task/data/entity/task_stats_entity.dart';

/// Status filter: null = all, false = pending, true = completed.
/// Priority filter: null = all, or "LOW" | "MEDIUM" | "HIGH".
class TaskListState extends Equatable {
  const TaskListState({
    this.tasks = const [],
    this.stats,
    this.pagination,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.statusFilter,
    this.priorityFilter,
    this.searchQuery,
  });

  final List<TaskEntity> tasks;
  final TaskPaginationEntity? pagination;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final String? error;
  final bool? statusFilter;
  final String? priorityFilter;
  final String? searchQuery;
  final TaskStatsEntity? stats;

  bool get hasNextPage => pagination?.hasNextPage ?? false;
  int get currentPage => pagination?.currentPage ?? 1;

  TaskListState copyWith({
    List<TaskEntity>? tasks,
    TaskPaginationEntity? pagination,
    bool? isInitialLoading,
    bool? isLoadingMore,
    String? error,
    bool? statusFilter,
    String? priorityFilter,
    String? searchQuery,
    TaskStatsEntity? stats,
  }) {
    return TaskListState(
      tasks: tasks ?? this.tasks,
      pagination: pagination ?? this.pagination,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      statusFilter: statusFilter ?? this.statusFilter,
      priorityFilter: priorityFilter ?? this.priorityFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [
        tasks,
        pagination,
        isInitialLoading,
        isLoadingMore,
        error,
        statusFilter,
        priorityFilter,
        stats,
        searchQuery,
      ];
}

/// State for create task (bottom sheet / flow).
class CreateTaskState extends Equatable {
  const CreateTaskState({
    this.isSubmitting = false,
    this.error,
    this.success = false,
  });

  final bool isSubmitting;
  final String? error;
  final bool success;

  @override
  List<Object?> get props => [isSubmitting, error, success];
}

/// State for single-task operations (update, delete, toggle).
class TaskOperationState extends Equatable {
  const TaskOperationState({
    this.operationId,
    this.isLoading = false,
    this.error,
  });

  final String? operationId;
  final bool isLoading;
  final String? error;

  @override
  List<Object?> get props => [operationId, isLoading, error];
}
