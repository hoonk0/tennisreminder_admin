import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TextInputFormatterNumber extends TextInputFormatter {
  TextInputFormatterNumber({this.maxDigits});

  final int? maxDigits;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String newText = newValue.text.replaceAll(',', '');
    if (maxDigits != null && newText.length > maxDigits!) {
      return oldValue;
    }

    int value = int.tryParse(newText) ?? 0;
    final formatter = NumberFormat('#,###', 'ko_KR');

    String formatted = formatter.format(value);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
