import 'package:flutter/material.dart';

class Toast {
  static void yoToast(
    String title,
    String description,
    BuildContext context,
  ) {
    final snack = SnackBar(
      content: Text("$title\n$description"),
      duration: const Duration(seconds: 2, milliseconds: 0),
      behavior: SnackBarBehavior.floating,
      width: 300,
      backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Code to execute.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
