import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onRefresh;

  const TopBar({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        border: Border(bottom: BorderSide(color: Color(0xFF1E1E1E))),
      ),
      child: Row(
        children: [
          const Text(
            'KPI',
            style: TextStyle(
              color: Color(0xFFFF4136),
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const Text(
            '-DRIVE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 16, color: const Color(0xFF2A2A2A)),
          const SizedBox(width: 16),
          const Text(
            'ЗАДАЧИ',
            style: TextStyle(
              color: Color(0xFF555555),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          _HeaderBtn(icon: Icons.refresh, label: 'ОБНОВИТЬ', onTap: onRefresh),
        ],
      ),
    );
  }
}

class _HeaderBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeaderBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF222222)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13, color: const Color(0xFF666666)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const ErrorBanner({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isCors = message.contains('403') || message.contains('CORS');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      color: const Color(0xFF1A0808),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 14, color: Color(0xFFFF4136)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCors ? '403 CORS — запустите Chrome с флагом:' : message,
                  style: const TextStyle(
                    color: Color(0xFFFF4136),
                    fontSize: 12,
                  ),
                ),
                if (isCors)
                  const Text(
                    'flutter run -d chrome --web-browser-flag "--disable-web-security"',
                    style: TextStyle(
                      color: Color(0xFFFF7066),
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
              ],
            ),
          ),
          InkWell(
            onTap: onDismiss,
            child: const Icon(Icons.close, size: 14, color: Color(0xFF555555)),
          ),
        ],
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Загрузка...',
            style: TextStyle(color: Color(0xFF333333), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Задачи не найдены',
        style: TextStyle(color: Color(0xFF2A2A2A), fontSize: 13),
      ),
    );
  }
}
