import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpi_test/models/task.dart';
import 'package:kpi_test/providers/task_provider.dart';

class BoardController {
  final WidgetRef ref;

  BoardController(this.ref);

  TaskState get _state => ref.read(taskProvider);

  List<int> get columnIds => _state.columns.keys.toList();

  void onItemDrop({
    required Task task,
    required int targetColumnId,
    required int targetIndex,
  }) {
    final ids = columnIds;
    if (!ids.contains(targetColumnId)) return;

    final targetTasks = _state.tasks[targetColumnId] ?? [];
    final clamped = targetIndex.clamp(0, targetTasks.length);

    ref
        .read(taskProvider.notifier)
        .moveTask(
          task: task,
          targetColumnId: targetColumnId,
          targetIndex: clamped,
        );
  }

  void onReorderWithinColumn({
    required Task task,
    required int columnId,
    required int newIndex,
  }) {
    final tasks = _state.tasks[columnId] ?? [];
    final clamped = newIndex.clamp(0, tasks.length - 1);

    ref
        .read(taskProvider.notifier)
        .moveTask(task: task, targetColumnId: columnId, targetIndex: clamped);
  }
}
