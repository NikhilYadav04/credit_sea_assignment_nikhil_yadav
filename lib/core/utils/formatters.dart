import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _rupees = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  static final _plain = NumberFormat.decimalPattern('en_IN');

  static String rupees(num value) => _rupees.format(value);

  static String number(num value) => _plain.format(value);

  static String maskedMobile(String mobile) => '+91 $mobile';
}
