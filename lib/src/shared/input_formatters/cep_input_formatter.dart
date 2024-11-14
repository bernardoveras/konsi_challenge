import 'package:flutter/services.dart';

/// Formats the field value with the ZIP code mask XX.XXX-XXX.
///
/// `usePoint` indicates whether the ZIP code format should use `.` or not.

class CepInputFormatter extends TextInputFormatter {
  final bool usePoint;

  CepInputFormatter({this.usePoint = false});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // verifica o tamanho máximo do campo
    if (newValue.text.length > 8) return oldValue;

    final valorFinal = StringBuffer();
    int posicaoCursor = newValue.selection.end;

    for (int i = 0; i < newValue.text.length; i++) {
      if (i == 2 && usePoint) {
        valorFinal.write('.');
        if (posicaoCursor > i) posicaoCursor++;
      }
      if (i == 5) {
        valorFinal.write('-');
        if (posicaoCursor > i) posicaoCursor++;
      }
      valorFinal.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: valorFinal.toString(),
      selection: TextSelection.collapsed(offset: posicaoCursor),
    );
  }
}
