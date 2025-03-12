import 'package:flutter/material.dart';

import 'alert_widget.dart';

class Alerts {
  static void showSuccess(BuildContext context, String message) {
    SnackBar snackBar = AlertWidget(
      color: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,
      message: message,
    ).build(context);

    show(context, snackBar);
  }

  static void showFailure(BuildContext context, String message) {
    SnackBar snackBar = AlertWidget(
      color: Colors.white,
      backgroundColor: Colors.red,
      message: message,
    ).build(context);

    show(context, snackBar);
  }

  static void show(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
