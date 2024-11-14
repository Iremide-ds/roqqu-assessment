import 'package:intl/intl.dart';

extension StringHelpers on String {
  String get currencyFormat {
    return NumberFormat.currency().format(this);
  }
}
