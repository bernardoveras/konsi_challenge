import '../extensions/extensions.dart';

abstract class CepValidator {
  static bool validate(String value) {
    value = value.removeSpecialCharacters()!;

    if (!value.isNumber()) return false;

    return value.length == 8;
  }
}
