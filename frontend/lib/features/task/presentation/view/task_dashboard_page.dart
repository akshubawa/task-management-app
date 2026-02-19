import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:task_management/core/constants/app_colors.dart';
import 'package:task_management/core/constants/app_dimensions.dart';
import 'package:task_management/core/utils/custom_app_bar.dart';
import 'package:task_management/core/utils/custom_textfield.dart';
import 'package:task_management/core/widgets/app_drawer.dart';
import 'package:task_management/features/task/data/entity/task_entity.dart';
import 'package:task_management/features/task/presentation/cubit/task_cubit.dart';
import 'package:task_management/features/task/presentation/cubit/task_state.dart';
import 'package:task_management/features/task/presentation/widgets/create_task_bottom_sheet.dart';
import 'package:task_management/features/task/presentation/widgets/task_filter_pills.dart';
import 'package:task_management/features/task/presentation/widgets/task_list_item.dart';
import 'package:task_management/features/task/presentation/widgets/task_list_item_shimmer.dart';
import 'package:task_management/features/task/presentation/widgets/task_summary_cards.dart';

/// Stateless task dashboard: summary cards, search, priority pills, task list with lazy load, FAB opens create sheet.
class TaskDashboardPage extends StatelessWidget {
  const TaskDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: CustomAppBar(title: 'My Tasks'),
      body: BlocConsumer<TaskCubit, TaskListState>(
        listenWhen: (a, b) => a.error != b.error,
        listener: (context, state) {
          if (state.error != null && state.error!.isNotEmpty) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
            title: Text(state.error!),
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          final completedCount = state.stats?.totalCompletedTasks ?? 0;
          final pendingCount = state.stats?.totalPendingTasks ?? 0;
          return RefreshIndicator(
            onRefresh: () => context.read<TaskCubit>().loadTasks(),
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            strokeWidth: 2.2,
            displacement: 48,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                final metrics = notification.metrics;
                if (metrics.pixels >= metrics.maxScrollExtent - 200 &&
                    state.hasNextPage &&
                    !state.isLoadingMore) {
                  context.read<TaskCubit>().loadMore();
                }
                return false;
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: AppDimensions.spacingL),
                        TaskSummaryCards(
                          completedCount: completedCount,
                          pendingCount: pendingCount,
                        ),
                        SizedBox(height: AppDimensions.spacingL),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.screenPaddingHorizontal,
                          ),
                          child: _TaskSearchField(
                            value: state.searchQuery,
                            onChanged: (v) =>
                                context.read<TaskCubit>().setSearchQuery(v),
                          ),
                        ),
                        SizedBox(height: AppDimensions.spacingL),
                        TaskFilterPills(
                          selectedIndex:
                              TaskFilterPillsHelper.selectedIndexFromFilters(
                                state.statusFilter,
                                state.priorityFilter,
                              ),
                          onSelected: (i) =>
                              context.read<TaskCubit>().setFilterByIndex(i),
                        ),
                        SizedBox(height: AppDimensions.spacingL),
                      ],
                    ),
                  ),
                  _TaskListSlivers(
                    state: state,
                    onConfirmDelete: (task) =>
                        _TaskListBody.confirmDelete(context, task),
                    onShowEditSheet: (task) =>
                        _TaskListBody.showEditSheet(context, task),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onCreateTask(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onCreateTask(BuildContext context) {
    CreateTaskBottomSheet.show(context, taskCubit: context.read<TaskCubit>());
  }
}

/// Builds slivers for the task list: loading shimmers, empty state, or task items.
class _TaskListSlivers extends StatelessWidget {
  const _TaskListSlivers({
    required this.state,
    required this.onConfirmDelete,
    required this.onShowEditSheet,
  });

  final TaskListState state;
  final void Function(TaskEntity task) onConfirmDelete;
  final void Function(TaskEntity task) onShowEditSheet;

  @override
  Widget build(BuildContext context) {
    if (state.isInitialLoading && state.tasks.isEmpty) {
      return SliverPadding(
        padding: EdgeInsets.only(bottom: AppDimensions.spacing6Xl),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.spacingM),
              child: const TaskListItemShimmer(),
            ),
            childCount: 6,
          ),
        ),
      );
    }
    if (state.tasks.isEmpty && state.error == null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'No tasks yet. Tap + to create one.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    final itemCount = state.tasks.length + (state.isLoadingMore ? 3 : 0);
    return SliverPadding(
      padding: EdgeInsets.only(
        top: AppDimensions.spacingS,
        bottom: AppDimensions.spacing6Xl,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= state.tasks.length) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.spacingM),
              child: const TaskListItemShimmer(),
            );
          }
          final task = state.tasks[index];
          return Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.spacingM),
            child: TaskListItem.fromEntity(
              task: task,
              onToggle: () => context.read<TaskCubit>().toggleTask(task.id),
              onDelete: () => onConfirmDelete(task),
              onEdit: () => onShowEditSheet(task),
            ),
          );
        }, childCount: itemCount),
      ),
    );
  }
}

class _TaskListBody {
  _TaskListBody._();

  static void confirmDelete(BuildContext context, TaskEntity task) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('"${task.title}" will be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<TaskCubit>().deleteTask(task.id);
            },
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  static void showEditSheet(BuildContext context, TaskEntity task) {
    CreateTaskBottomSheet.show(
      context,
      taskCubit: context.read<TaskCubit>(),
      editTask: task,
    );
  }
}

class _TaskSearchField extends StatefulWidget {
  const _TaskSearchField({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String> onChanged;

  @override
  State<_TaskSearchField> createState() => _TaskSearchFieldState();
}

class _TaskSearchFieldState extends State<_TaskSearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
  }

  @override
  void didUpdateWidget(_TaskSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      hintText: 'Search tasks...',
      fieldType: InputFieldType.search,
      fieldSize: InputFieldSize.medium,
      onChanged: widget.onChanged,
    );
  }
}
