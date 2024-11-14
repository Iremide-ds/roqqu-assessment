import 'dart:async';
import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:dio/dio.dart';
import 'package:roqqu_assessment/src/core/constants/app_constants.dart';
import 'package:roqqu_assessment/src/core/error/exception.dart';
import 'package:roqqu_assessment/src/features/home/data/models/response/symbol_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract interface class BinanceRemoteDataSource {
  Future<List<SymbolResponseModel>> getSymbols();
  Future<List<Candle>> getCandles({
    required String symbol,
    required String interval,
    int? endTime,
  });
  FutureOr<WebSocketChannel> establishSocketConnection({
    required String symbol,
    required String interval,
  });
}

class BinanceRemoteDataSourceImpl implements BinanceRemoteDataSource {
  final Dio _restClient;

  const BinanceRemoteDataSourceImpl({required Dio restClient})
      : _restClient = restClient;

  FutureOr<T> _runFn<T>(FutureOr<T> Function() fn) async {
    try {
      return await fn();
    } catch (e, t) {
      throw (T is WebSocketChannel
          ? AppException(error: e, t: t)
          : BinanceException(error: e, t: t));
    }
  }

  @override
  establishSocketConnection(
      {required String symbol, required String interval}) async {
    return await _runFn<WebSocketChannel>(() {
      final channel = WebSocketChannel.connect(
        Uri.parse(AppConstants.webSocketBaseURL),
      );

      channel.sink.add(
        jsonEncode(
          {
            'method': 'SUBSCRIBE',
            'params': ['$symbol@kline_$interval'],
            'id': 1
          },
        ),
      );
      channel.sink.add(
        jsonEncode(
          {
            'method': 'SUBSCRIBE',
            'params': ['$symbol@depth'],
            'id': 1
          },
        ),
      );

      return channel;
    });
  }

  @override
  Future<List<Candle>> getCandles(
      {required String symbol, required String interval, int? endTime}) async {
    return await _runFn(() async {
      final String uri =
          "https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval${endTime != null ? "&endTime=$endTime" : ""}";
      final response = await _restClient.get(uri);
      final data = response.data as List;

      return data.map((e) => Candle.fromJson(e)).toList().reversed.toList();
    });
  }

  @override
  Future<List<SymbolResponseModel>> getSymbols() async {
    return await _runFn(() async {
      const uri = "https://api.binance.com/api/v3/ticker/price";
      final response = await _restClient.get(uri);
      final data = response.data as List;
      final arr = data.map((e) => SymbolResponseModel.fromMap(e)).toList();

      return arr;
    });
  }
}
