import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';

extension ResultSnackbarExtension on Result<Object, GenericFailure> {
  bool displaySnackbarWhenError(BuildContext context) {
    if (isSuccess()) return false;

    final exception = exceptionOrNull()!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(exception.message),
        backgroundColor: Colors.red,
      ),
    );

    return true;
  }
}
