import 'package:flutter/material.dart';
import 'package:kpi_test/controllers/board_controller.dart';
import 'package:kpi_test/models/card_drag.dart';
import 'package:kpi_test/models/task.dart';
import 'package:kpi_test/widgets/drag_feedback.dart';
import 'package:kpi_test/widgets/task_card.dart';

class KanbanColumn extends StatefulWidget {
  final int columnId;
  final String columnName;
  final List<Task> tasks;
  final Set<int> savingTasks;
  final BoardController controller;

  const KanbanColumn({
    super.key,
    required this.columnId,
    required this.columnName,
    required this.tasks,
    required this.savingTasks,
    required this.controller,
  });

  @override
  State<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends State<KanbanColumn> {
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<CardDrag>(
      onWillAcceptWithDetails: (details) {
        if (details.data.sourceColumnId == widget.columnId) return false;
        setState(() => _isDragOver = true);
        return true;
      },
      onLeave: (_) => setState(() => _isDragOver = false),
      onAcceptWithDetails: (details) {
        setState(() => _isDragOver = false);
        widget.controller.onItemDrop(
          task: details.data.task,
          targetColumnId: widget.columnId,
          targetIndex: widget.tasks.length,
        );
      },
      builder: (context, candidateData, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),

          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: _isDragOver
                ? const Color(0xFF161616)
                : const Color(0xFF111111),
            border: Border(
              top: BorderSide(
                color: _isDragOver
                    ? const Color(0xFF555555)
                    : const Color(0xFF2A2A2A),
                width: 2,
              ),
              left: const BorderSide(color: Color(0xFF1A1A1A)),
              right: const BorderSide(color: Color(0xFF1A1A1A)),
              bottom: const BorderSide(color: Color(0xFF1A1A1A)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _ColumnHeader(
                name: widget.columnName,
                count: widget.tasks.length,
              ),
              if (widget.tasks.isEmpty)
                _EmptyColumnHint(isHovered: _isDragOver)
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.tasks.length,
                  itemBuilder: (ctx, i) {
                    final task = widget.tasks[i];
                    return DraggableCard(
                      key: ValueKey(task.indicatorToMoId),
                      task: task,
                      sourceColumnId: widget.columnId,
                      isSaving: widget.savingTasks.contains(
                        task.indicatorToMoId,
                      ),
                      onReorder: (draggedTask, targetIndex) {
                        widget.controller.onReorderWithinColumn(
                          task: draggedTask,
                          columnId: widget.columnId,
                          newIndex: targetIndex,
                        );
                      },
                      index: i,
                      totalInColumn: widget.tasks.length,
                    );
                  },
                ),
              if (_isDragOver && widget.tasks.isNotEmpty)
                const DropZoneIndicator(),
            ],
          ),
        );
      },
    );
  }
}

class DraggableCard extends StatefulWidget {
  final Task task;
  final int sourceColumnId;
  final bool isSaving;
  final void Function(Task draggedTask, int targetIndex) onReorder;
  final int index;
  final int totalInColumn;

  const DraggableCard({
    super.key,
    required this.task,
    required this.sourceColumnId,
    required this.isSaving,
    required this.onReorder,
    required this.index,
    required this.totalInColumn,
  });

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  bool _isBeingDraggedOver = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<CardDrag>(
      onWillAcceptWithDetails: (details) {
        if (details.data.task.indicatorToMoId == widget.task.indicatorToMoId) {
          return false;
        }
        if (details.data.sourceColumnId != widget.sourceColumnId) {
          return false;
        }
        setState(() => _isBeingDraggedOver = true);
        return true;
      },
      onLeave: (_) => setState(() => _isBeingDraggedOver = false),
      onAcceptWithDetails: (details) {
        setState(() => _isBeingDraggedOver = false);
        widget.onReorder(details.data.task, widget.index);
      },
      builder: (ctx, candidate, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          decoration: _isBeingDraggedOver
              ? const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFFF4136), width: 2),
                  ),
                )
              : const BoxDecoration(),
          child: Draggable<CardDrag>(
            data: CardDrag(
              task: widget.task,
              sourceColumnId: widget.sourceColumnId,
            ),
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 280,
                child: DragFeedback(task: widget.task),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.2,
              child: TaskCard(task: widget.task, isSaving: widget.isSaving),
            ),
            child: TaskCard(task: widget.task, isSaving: widget.isSaving),
          ),
        );
      },
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  final String name;
  final int count;

  const _ColumnHeader({required this.name, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1E1E1E))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF999999),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Color(0xFF555555),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyColumnHint extends StatelessWidget {
  final bool isHovered;

  const _EmptyColumnHint({required this.isHovered});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: Text(
          isHovered ? 'Перетащите задачу сюда' : 'Нет задач',
          style: TextStyle(
            color: isHovered
                ? const Color(0xFF555555)
                : const Color(0xFF2A2A2A),
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
