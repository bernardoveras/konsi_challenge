import 'package:flutter_test/flutter_test.dart';
import 'package:konsi_challenge/src/shared/validators/validators.dart';

void main() {
  test(
    '(Fail) Not number',
    () {
      const invalidCep = 'invalid_cep';

      expect(CepValidator.validate(invalidCep), false);
    },
  );

  test(
    '(Fail) Number and letters',
    () {
      const invalidCep = '1234567p';

      expect(CepValidator.validate(invalidCep), false);
    },
  );

  test(
    '(Fail) Invalid length',
    () {
      const invalidCep = '1234567890';

      expect(CepValidator.validate(invalidCep), false);
    },
  );

  test(
    '(Success) Valid',
    () {
      const invalidCep = '12345678';

      expect(CepValidator.validate(invalidCep), true);
    },
  );

  test(
    '(Success) Valid with special characters',
    () {
      const invalidCep = '123456-78';

      expect(CepValidator.validate(invalidCep), true);
    },
  );
}
