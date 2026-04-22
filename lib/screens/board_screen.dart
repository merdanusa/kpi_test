import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kpi_test/controllers/board_controller.dart';
import 'package:kpi_test/providers/task_provider.dart';
import 'package:kpi_test/widgets/kanban_column.dart';
import 'package:kpi_test/widgets/top_bar.dart';

class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({super.key});

  @override
  ConsumerState<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends ConsumerState<BoardScreen> {
  late final BoardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BoardController(ref);
    Future.microtask(() => ref.read(taskProvider.notifier).loadTasks());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TopBar(onRefresh: () => ref.read(taskProvider.notifier).loadTasks()),
          if (state.error != null)
            ErrorBanner(
              message: state.error!,
              onDismiss: () => ref.read(taskProvider.notifier).clearError(),
            ),
          Expanded(
            child: state.isLoading
                ? const LoadingView()
                : state.columns.isEmpty
                ? const EmptyView()
                : _KanbanBoard(controller: _controller),
          ),
        ],
      ),
    );
  }
}

class _KanbanBoard extends ConsumerWidget {
  final BoardController controller;

  const _KanbanBoard({required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskProvider);
    final columnIds = state.columns.keys.toList();
    final screenWidth = MediaQuery.of(context).size.width;

    final int crossAxisCount = screenWidth < 480
        ? 1
        : screenWidth < 768
        ? 2
        : screenWidth < 1100
        ? 3
        : 4;

    final rows = <List<int>>[];
    for (var i = 0; i < columnIds.length; i += crossAxisCount) {
      rows.add(
        columnIds.sublist(i, (i + crossAxisCount).clamp(0, columnIds.length)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows.map((rowIds) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 14,
            children: rowIds.map((colId) {
              return Expanded(
                child: KanbanColumn(
                  key: ValueKey(colId),
                  columnId: colId,
                  columnName: state.columns[colId]!,
                  tasks: state.tasks[colId] ?? [],
                  savingTasks: state.savingTasks,
                  controller: controller,
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
