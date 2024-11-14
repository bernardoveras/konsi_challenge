import 'package:flutter/material.dart';

import '../../extensions/extensions.dart';
import '../cep_validator.dart';

abstract class CepValidatorless {
  static FormFieldValidator<String> validate([
    String message = 'Informe um CEP válido',
  ]) {
    return (value) {
      value = value.removeSpecialCharacters();

      if (value.isBlank) return null;

      final isValid = CepValidator.validate(value!);

      if (!isValid) return message;

      return null;
    };
  }
}
