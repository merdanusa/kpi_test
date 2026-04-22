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
    final scrollController = ScrollController();

    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 14,
          children: columnIds.map((colId) {
            return SizedBox(
              width: 280,
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
        ),
      ),
    );
  }
}
