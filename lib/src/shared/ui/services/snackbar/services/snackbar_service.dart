import 'package:flutter/material.dart';

import '../enums/snackbar_type.dart';

abstract class SnackbarService {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: type.foregroundColor,
          ),
        ),
        backgroundColor: type.backgroundColor,
      ),
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
  }) =>
      show(
        context,
        message: message,
        type: SnackbarType.error,
      );

  static void showSuccess(
    BuildContext context, {
    required String message,
  }) =>
      show(
        context,
        message: message,
        type: SnackbarType.success,
      );
}
