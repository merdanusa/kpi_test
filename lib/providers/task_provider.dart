import 'package:flutter_riverpod/legacy.dart';
import 'package:kpi_test/models/task.dart';
import 'package:kpi_test/services/api.dart';

class TaskState {
  final Map<int, String> columns;
  final Map<int, List<Task>> tasks;
  final bool isLoading;
  final String? error;
  final Set<int> savingTasks;

  const TaskState({
    this.columns = const {},
    this.tasks = const {},
    this.isLoading = false,
    this.error,
    this.savingTasks = const {},
  });

  TaskState copyWith({
    Map<int, String>? columns,
    Map<int, List<Task>>? tasks,
    bool? isLoading,
    String? error,
    bool clearError = false,
    Set<int>? savingTasks,
  }) => TaskState(
    columns: columns ?? this.columns,
    tasks: tasks ?? this.tasks,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : (error ?? this.error),
    savingTasks: savingTasks ?? this.savingTasks,
  );
}

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier(ApiService.instance);
});

class TaskNotifier extends StateNotifier<TaskState> {
  final ApiService api;

  TaskNotifier(this.api) : super(const TaskState());

  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final raw = await api.getTasks();
      final all = raw.map((e) => Task.fromJson(e)).toList();

      final Map<int, String> columns = {};
      final Map<int, List<Task>> tasks = {};

      for (final task in all) {
        final pid = task.parentId;
        if (!columns.containsKey(pid)) {
          columns[pid] = 'Column ${columns.length + 1}';
          tasks[pid] = [];
        }
      }

      for (final task in all) {
        tasks[task.parentId]!.add(task);
      }

      for (final list in tasks.values) {
        list.sort((a, b) => a.order.compareTo(b.order));
      }

      state = state.copyWith(columns: columns, tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> moveTask({
    required Task task,
    required int targetColumnId,
    required int targetIndex,
  }) async {
    final oldTasks = Map<int, List<Task>>.from(
      state.tasks.map((k, v) => MapEntry(k, List<Task>.from(v))),
    );

    final sourceList = List<Task>.from(state.tasks[task.parentId] ?? []);
    sourceList.removeWhere((t) => t.indicatorToMoId == task.indicatorToMoId);

    final targetList = task.parentId == targetColumnId
        ? sourceList
        : List<Task>.from(state.tasks[targetColumnId] ?? []);

    final clampedIndex = targetIndex.clamp(0, targetList.length);
    final movedTask = task.copyWith(
      parentId: targetColumnId,
      order: clampedIndex,
    );
    targetList.insert(clampedIndex, movedTask);

    for (int i = 0; i < targetList.length; i++) {
      targetList[i] = targetList[i].copyWith(order: i);
    }

    final newTasks = Map<int, List<Task>>.from(oldTasks);
    newTasks[task.parentId] = sourceList;
    newTasks[targetColumnId] = targetList;

    state = state.copyWith(tasks: newTasks);

    final saving = Set<int>.from(state.savingTasks)..add(task.indicatorToMoId);
    state = state.copyWith(savingTasks: saving);

    try {
      await ApiService.moveTask(
        indicatorToMoId: task.indicatorToMoId,
        newParentId: targetColumnId,
        newOrder: clampedIndex,
      );
    } catch (e) {
      state = state.copyWith(tasks: oldTasks, error: 'Move failed: $e');
    } finally {
      final done = Set<int>.from(state.savingTasks)
        ..remove(task.indicatorToMoId);
      state = state.copyWith(savingTasks: done);
    }
  }

  void clearError() => state = state.copyWith(clearError: true);
}
