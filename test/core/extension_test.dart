import 'package:expense_tracker/core/extensions/date_formatter.dart';
import 'package:expense_tracker/core/extensions/number_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String normalize(String input) {
    return input.replaceAll('\u00A0', ' ').trim();
  }

  test('get string euro currency format', () {
    const num value = 10.50;
    const String expected = '10,50 €';

    final String actual = value.toEuroFormat;

    expect(normalize(actual), normalize(expected));
  });

  test('get string euro currency format', () {
    const num value = 10.50;
    const String expected = '10,50 €';

    final String actual = value.toEuroFormat;

    expect(normalize(actual), normalize(expected));
  });

  test('get string from date for the interface', () {
    final date = DateTime(1994, 10, 15).getStringUIDate;

    expect(date, '15 Oct 1994');
  });
}
