import 'package:candlesticks/candlesticks.dart';
import 'package:roqqu_assessment/src/features/home/domain/entities/candle_ticker_data.dart';

class CandleTickerDataModel extends CandleTickerData {
  const CandleTickerDataModel({
    required super.eventTime,
    required super.candle,
    required super.symbol,
  });

  factory CandleTickerDataModel.fromJson(Map<String, dynamic> json) {
    return CandleTickerDataModel(
      symbol: json['s'] as String,
      eventTime: json['E'] as int,
      candle: Candle(
        open: double.parse(json['k']['o']),
        close: double.parse(json['k']['c']),
        volume: double.parse(json['k']['v']),
        date: DateTime.fromMillisecondsSinceEpoch(json['k']['t']),
        high: double.parse(json['k']['h']),
        low: double.parse(json['k']['l']),
      ),
    );
  }
}
