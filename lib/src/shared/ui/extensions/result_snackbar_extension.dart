import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../services/snackbar/services/snackbar_service.dart';

extension ResultSnackbarExtension on Result<Object, GenericFailure> {
  bool displaySnackbarWhenError(BuildContext context) {
    if (isSuccess()) return false;

    final exception = exceptionOrNull()!;

    SnackbarService.showError(
      context,
      message: exception.message,
    );

    return true;
  }
}
