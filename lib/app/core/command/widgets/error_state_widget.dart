import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? refresh;

  const ErrorStateWidget({
    super.key,
    this.message,
    this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 34,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Erro ao carregar dados',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            if (refresh != null)
              ElevatedButton.icon(
                onPressed: refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
          ],
        ),
      ),
    );
  }
}
