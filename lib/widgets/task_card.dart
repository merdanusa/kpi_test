import 'package:flutter/material.dart';
import 'package:kpi_test/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isSaving;

  const TaskCard({super.key, required this.task, this.isSaving = false});

  Color get _statusColor {
    final o = task.order;
    if (o >= 80) return const Color(0xFF2ECC40);
    if (o >= 40) return const Color(0xFFFFDC00);
    return const Color(0xFFFF4136);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        border: Border(
          bottom: BorderSide(color: Color(0xFF222222)),
          left: BorderSide(color: Color(0xFF1A1A1A)),
          right: BorderSide(color: Color(0xFF1A1A1A)),
          top: BorderSide(color: Color(0xFF1A1A1A)),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          hoverColor: const Color(0xFF1E1E1E),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _statusColor,
                  ),
                  alignment: Alignment.center,
                  child: isSaving
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          '${task.order}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name,
                        style: const TextStyle(
                          color: Color(0xFFDDDDDD),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${task.indicatorToMoId}',
                        style: const TextStyle(
                          color: Color(0xFF444444),
                          fontSize: 10,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.drag_indicator,
                  size: 16,
                  color: Color(0xFF333333),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
