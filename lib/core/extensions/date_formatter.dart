import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String get getStringUIDate {
    return DateFormat('d MMM yyyy').format(this);
  }
}
