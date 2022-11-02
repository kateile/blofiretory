import 'package:flutter/material.dart';

displaySuccess({
  required BuildContext context,
  required String message,
  int? duration,
}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.green,
    duration: Duration(seconds: duration ?? 10),
    action: SnackBarAction(
      label: 'Close',
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

  // Find the Scaffold in the widget tree and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

displayError({
  required BuildContext context,
  required String message,
  VoidCallback? retryCallback,
}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 30),
    action: retryCallback != null
        ? SnackBarAction(
      label: 'Retry',
      textColor: Colors.white,
      onPressed: retryCallback,
    )
        : SnackBarAction(
      label: 'Close',
      textColor: Colors.white,
      onPressed: () {},
    ),
  );

  // Find the Scaffold in the widget tree and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
