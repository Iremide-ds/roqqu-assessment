import 'package:candlesticks/candlesticks.dart';

class CandleTickerData {
  final int eventTime;
  final String symbol;
  final Candle candle;
  const CandleTickerData({
    required this.eventTime,
    required this.candle,
    required this.symbol,
  });
}
