import 'package:intl/intl.dart';

extension NumHelpers on num {
  String get currencyFormat {
    return NumberFormat.currency(symbol: "\$").format(this);
  }
}
