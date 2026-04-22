import 'package:flutter/material.dart';
import 'package:kpi_test/models/task.dart';

class DragFeedback extends StatelessWidget {
  final Task task;

  const DragFeedback({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        border: Border.fromBorderSide(BorderSide(color: Color(0xFF555555))),
        boxShadow: [
          BoxShadow(
            color: Color(0xCC000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        task.name,
        style: const TextStyle(
          color: Color(0xFFDDDDDD),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class DropZoneIndicator extends StatelessWidget {
  const DropZoneIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF333333),
          style: BorderStyle.solid,
        ),
      ),
      child: const Center(
        child: Text(
          'Переместить сюда',
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 11,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
