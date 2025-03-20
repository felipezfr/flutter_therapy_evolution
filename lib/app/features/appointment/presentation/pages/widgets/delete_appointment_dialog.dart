import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeleteAppointmentDialog {
  static Future<int> showRecurringDelete({
    required BuildContext context,
    required String patientName,
    required DateTime appointmentDate,
    String title = 'Excluir Agendamento',
    String cancelButtonText = 'Cancelar',
    String onlyThisButtonText = 'Apenas Este',
    String allButtomText = 'Toda a Série',
    Function()? onConfirmOnlyThis,
    Function()? onConfirmAll,
    Function()? onCancel,
  }) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Agendamento'),
        content: Text(
          'Deseja realmente excluir o agendamento de $patientName em ${DateFormat('dd/MM/yyyy HH:mm').format(appointmentDate)}?'
          '\n\nDeseja excluir apenas este agendamento ou toda a série?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (onConfirmOnlyThis != null) {
                onConfirmOnlyThis();
              }
              Navigator.of(context).pop(1);
            },
            child: const Text('Apenas Este'),
          ),
          TextButton(
            onPressed: () {
              if (onConfirmAll != null) {
                onConfirmAll();
              }
              Navigator.of(context).pop(2);
            },
            child: const Text('Toda a Série'),
          ),
          TextButton(
            onPressed: () {
              if (onCancel != null) {
                onCancel();
              }
              Navigator.of(context).pop(-1);
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
    return result ?? -1;
  }
}
