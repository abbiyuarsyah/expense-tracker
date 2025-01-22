import 'package:intl/intl.dart';

extension NumberFormatter on num {
  String get toEuroFormat {
    final euroFormatter = NumberFormat.simpleCurrency(
      locale: 'de_DE',
      name: 'EUR',
    );
    return euroFormatter.format(this);
  }
}
