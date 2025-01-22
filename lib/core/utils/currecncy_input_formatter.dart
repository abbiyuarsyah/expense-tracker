import 'package:flutter/services.dart';

class CurrencyTextInputFormatter extends TextInputFormatter {
  final String locale;

  CurrencyTextInputFormatter({required this.locale});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String value = newValue.text.replaceAll(RegExp(r'[^0-9,]'),
        ''); // Remove any non-numeric characters except comma
    if (value.isEmpty) return newValue;

    // Insert periods as thousand separators (German format)
    StringBuffer formattedValue = StringBuffer();
    int commaIndex = value.indexOf(',');

    // Handle decimal part
    if (commaIndex != -1) {
      String wholePart = value.substring(0, commaIndex);
      String decimalPart = value.substring(commaIndex + 1);
      formattedValue.write(_formatWithThousandSeparator(wholePart));
      formattedValue.write(',');
      formattedValue.write(
          decimalPart.length > 2 ? decimalPart.substring(0, 2) : decimalPart);
    } else {
      formattedValue.write(_formatWithThousandSeparator(value));
    }

    return TextEditingValue(
      text: formattedValue.toString(),
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _formatWithThousandSeparator(String value) {
    StringBuffer result = StringBuffer();
    int length = value.length;
    int count = 0;

    for (int i = length - 1; i >= 0; i--) {
      result.write(value[i]);
      count++;
      if (count == 3 && i != 0) {
        result.write('.'); // Add thousand separator
        count = 0;
      }
    }

    return result.toString().split('').reversed.join();
  }
}
