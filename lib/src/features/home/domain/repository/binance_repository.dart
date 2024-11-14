import 'dart:async';

import 'package:candlesticks/candlesticks.dart';
import 'package:roqqu_assessment/src/core/error/failure.dart';
import 'package:roqqu_assessment/src/features/home/domain/entities/symbol.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract interface class BinanceRepository {
  Future<(List<SymbolResponse>?, Failure?)> getSymbols();
  Future<(List<Candle>?, Failure?)> getCandles({
    required String symbol,
    required String interval,
    int? endTime,
  });
  FutureOr<(WebSocketChannel?, Failure?)> establishSocketConnection({
    required String symbol,
    required String interval,
  });
}
