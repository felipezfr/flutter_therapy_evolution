import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../alert/alerts.dart';
import '../state_management/errors/base_exception.dart';

class ResultHandler {
  /// Processa o resultado de uma operação que pode ter sucesso ou falha
  static void showAlert<Out extends Object>({
    required BuildContext context,
    required Result<Out, BaseException>? result,
    required String successMessage,
    String? failureMessage,
    bool showSuccessAlert = true,
    bool showFailureAlert = true,
    Function(Out)? onSuccess,
  }) {
    if (result == null) return;

    result.fold(
      (success) {
        if (showSuccessAlert) {
          Alerts.showSuccess(context, successMessage);
        }
        if (onSuccess != null) {
          onSuccess(success);
        }
      },
      (failure) {
        if (showFailureAlert) {
          Alerts.showFailure(context, failureMessage ?? failure.message);
        }
      },
    );
  }
}
