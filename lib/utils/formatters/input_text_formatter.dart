import 'package:flutter/services.dart';

class FirstDigitNotZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty && newValue.text[0] == '0') {
      // If the first character is '0', return the old value to prevent input.
      return oldValue;
    }
    return newValue;
  }
}

class NoDotAndComaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.contains('.') && newValue.text.contains(',')) {
      // If the first character is '0', return the old value to prevent input.
      return oldValue;
    }
    return newValue;
  }
}
