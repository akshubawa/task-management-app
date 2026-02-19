import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/features/task/data/entity/task_stats_entity.dart';
import 'package:task_management/features/task/data/model/create_task_body.dart';
import 'package:task_management/features/task/domain/repository/task_repository.dart';
import 'package:task_management/features/task/presentation/cubit/task_state.dart';

class TaskCubit extends Cubit<TaskListState> {
  TaskCubit(this._repository) : super(const TaskListState());

  final TaskRepository _repository;
  Timer? _searchDebounce;

  static const int _pageSize = 8;

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> loadTasks() async {
    emit(state.copyWith(isInitialLoading: true, error: null));
    try {
      final result = await _repository.getTasks(
        page: 1,
        limit: _pageSize,
        status: state.statusFilter,
        priority: state.priorityFilter,
        search: state.searchQuery,
      );
      emit(
        state.copyWith(
          tasks: result.tasks,
          pagination: result.pagination,
          stats: result.stats,
          isInitialLoading: false,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isInitialLoading: false,
          error: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  /// Single filter pill: 0 = All (no filter), 1 = Pending, 2 = Completed, 3 = Low, 4 = Medium, 5 = High.
  void setFilterByIndex(int index) {
    bool? statusFilter;
    String? priorityFilter;
    switch (index) {
      case 0:
        statusFilter = null;
        priorityFilter = null;
        break;
      case 1:
        statusFilter = false;
        priorityFilter = null;
        break;
      case 2:
        statusFilter = true;
        priorityFilter = null;
        break;
      case 3:
        statusFilter = null;
        priorityFilter = 'LOW';
        break;
      case 4:
        statusFilter = null;
        priorityFilter = 'MEDIUM';
        break;
      case 5:
        statusFilter = null;
        priorityFilter = 'HIGH';
        break;
      default:
        statusFilter = null;
        priorityFilter = null;
    }
    // Emit state with explicit filters so "All" (null, null) is applied correctly;
    // copyWith would keep previous values when passing null.
    emit(
      TaskListState(
        tasks: const [],
        pagination: null,
        isInitialLoading: true,
        isLoadingMore: false,
        error: null,
        statusFilter: statusFilter,
        priorityFilter: priorityFilter,
        searchQuery: state.searchQuery,
      ),
    );
    loadTasks();
  }

  /// Updates search query and refetches. Debounced by 400ms when query is non-empty.
  void setSearchQuery(String value) {
    final trimmed = value.trim();
    final search = trimmed.isEmpty ? null : trimmed;
    _searchDebounce?.cancel();
    emit(
      TaskListState(
        tasks: const [],
        pagination: null,
        isInitialLoading: true,
        isLoadingMore: false,
        error: null,
        statusFilter: state.statusFilter,
        priorityFilter: state.priorityFilter,
        searchQuery: search,
      ),
    );
    if (search == null || search.isEmpty) {
      loadTasks();
    } else {
      _searchDebounce = Timer(const Duration(milliseconds: 400), () {
        loadTasks();
        _searchDebounce = null;
      });
    }
  }

  Future<void> loadMore() async {
    if (!state.hasNextPage || state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true, error: null));
    try {
      final nextPage = state.currentPage + 1;
      final result = await _repository.getTasks(
        page: nextPage,
        limit: _pageSize,
        status: state.statusFilter,
        priority: state.priorityFilter,
        search: state.searchQuery,
      );
      emit(
        state.copyWith(
          tasks: [...state.tasks, ...result.tasks],
          pagination: result.pagination,
          isLoadingMore: false,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          error: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> createTask(CreateTaskBody body) async {
    try {
      final task = await _repository.createTask(body);
      emit(state.copyWith(tasks: [task, ...state.tasks]));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask(String id, Map<String, dynamic> body) async {
    try {
      final updated = await _repository.updateTask(id, body);
      final index = state.tasks.indexWhere((t) => t.id == id);
      if (index >= 0) {
        final newList = List.of(state.tasks)..[index] = updated;
        emit(state.copyWith(tasks: newList));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _repository.deleteTask(id);
      emit(
        state.copyWith(tasks: state.tasks.where((t) => t.id != id).toList()),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleTask(String id) async {
    try {
      final updated = await _repository.toggleTask(id);
      final index = state.tasks.indexWhere((t) => t.id == id);
      if (index >= 0) {
        final oldTask = state.tasks[index];
        final newList = List.of(state.tasks)..[index] = updated;
        final TaskStatsEntity? newStats = _statsAfterToggle(
          state.stats,
          wasCompleted: oldTask.status,
          nowCompleted: updated.status,
        );
        emit(state.copyWith(
          tasks: newList,
          stats: newStats,
          error: null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  /// Updates stats when a single task is toggled (completed <-> pending).
  TaskStatsEntity? _statsAfterToggle(
    TaskStatsEntity? current, {
    required bool wasCompleted,
    required bool nowCompleted,
  }) {
    if (current == null || wasCompleted == nowCompleted) return current;
    final completed = current.totalCompletedTasks + (nowCompleted ? 1 : -1);
    final pending = current.totalPendingTasks + (nowCompleted ? -1 : 1);
    return TaskStatsEntity(
      totalTasks: current.totalTasks,
      totalCompletedTasks: completed,
      totalPendingTasks: pending,
    );
  }
}
