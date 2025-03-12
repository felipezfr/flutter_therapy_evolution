import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? emptyMessage;
  const EmptyStateWidget({
    super.key,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            emptyMessage ?? 'Nenhum agendamento encontrado',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Clique no botão + para adicionar um agendamento',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
