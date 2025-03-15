import 'package:flutter/material.dart';

class DeleteDialog {
  /// Exibe um diálogo de confirmação de exclusão genérico
  static Future<bool> showDeleteConfirmation({
    required BuildContext context,
    String? title,
    required String entityName,
    String cancelButtonText = 'Cancelar',
    String confirmButtonText = 'Excluir',
    Function()? onConfirm,
    Function()? onCancel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title ?? 'Excluir Evolução',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          'Deseja realmente excluir $entityName?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (onCancel != null) {
                onCancel();
              }
              Navigator.of(context).pop(false);
            },
            child: Text(cancelButtonText),
          ),
          TextButton(
            onPressed: () {
              if (onConfirm != null) {
                onConfirm();
              }
              Navigator.of(context).pop(true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(confirmButtonText),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
