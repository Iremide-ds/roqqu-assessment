import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:roqqu_assessment/src/core/common/util/logger.dart';
import 'package:roqqu_assessment/src/core/interfaces/use_cases.dart';
import 'package:roqqu_assessment/src/dependencies/init_dependencies.dart';
import 'package:roqqu_assessment/src/features/home/data/models/response/candle_ticker_data_model.dart';
import 'package:roqqu_assessment/src/features/home/data/models/response/order_book_model.dart';
import 'package:roqqu_assessment/src/features/home/domain/entities/candle_ticker_data.dart';
import 'package:roqqu_assessment/src/features/home/domain/entities/order_book.dart';
import 'package:roqqu_assessment/src/features/home/domain/entities/symbol.dart';
import 'package:roqqu_assessment/src/features/home/domain/use_cases/establish_socket_connection.dart';
import 'package:roqqu_assessment/src/features/home/domain/use_cases/get_candles.dart';
import 'package:roqqu_assessment/src/features/home/domain/use_cases/get_symbols.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceController extends ChangeNotifier {
  final GetSymbols _getSymbols;
  final GetCandles _getCandles;
  final EstablishSocketConnection _establishSocketConnection;

  BinanceController({
    required GetSymbols getSymbols,
    required GetCandles getCandles,
    required EstablishSocketConnection establishSocketConnection,
  })  : _getSymbols = getSymbols,
        _getCandles = getCandles,
        _establishSocketConnection = establishSocketConnection;

  List<SymbolResponse> _symbols = [];
  List<Candle> _candles = [];

  SymbolResponse? _currentSymbol;
  WebSocketChannel? _channel;
  CandleTickerData? _candleTicker;
  OrderBook? _orderBooks;

  // * UI variables
  String _currentInterval = "1H";
  int _currentTabIndex = 0;
  int _bottomTabIndex = 0;
  int _selectedInterval = 0;

  BinanceControllerState _state = BinanceControllerState.gettingSymbols;

  List<SymbolResponse> get symbols => _symbols;

  List<Candle> get candles => _candles;

  SymbolResponse? get currentSymbol => _currentSymbol;

  WebSocketChannel? get channel => _channel;

  CandleTickerData? get candleTicker => _candleTicker;

  OrderBook? get orderBooks => _orderBooks;

  String get currentInterval => _currentInterval;

  int get currentTabIndex => _currentTabIndex;

  int get bottomTabIndex => _bottomTabIndex;

  int get selectedInterval => _selectedInterval;

  BinanceControllerState get state => _state;

  set _setState(BinanceControllerState value) {
    _state = value;
    notifyListeners();
  }

  set _setCandleTicker(CandleTickerData value) {
    _candleTicker = value;
    notifyListeners();
  }

  set _setOrderBook(OrderBook value) {
    _orderBooks = value;
    notifyListeners();
  }

  set bottomTabIndex(int value) {
    _bottomTabIndex = value;
    notifyListeners();
  }

  set tabIndex(int value) {
    _currentTabIndex = value;
    notifyListeners();
  }

  set interval(String value) {
    _currentInterval = value;
    notifyListeners();
  }

  set setCurrentSymbol(SymbolResponse value) {
    _currentSymbol = value;
    notifyListeners();
  }

  set selectedInterval(int index) {
    _selectedInterval = index;
    notifyListeners();
  }

  void _resetState() {
    _state = BinanceControllerState.initial;
    notifyListeners();
  }

  Future<String?> init([bool refreshSymbols = true]) async {
    String? error;
    if (refreshSymbols) error = await getSymbols();
    if (currentSymbol != null) {
      error = await getCandles(
        symbol: currentSymbol!,
        interval: currentInterval,
      );

      if (candleTicker == null) {
        initializeWebSocket(
          symbol: currentSymbol?.symbol ?? "",
          interval: currentInterval,
        );
      }
    }
    return error;
  }

  Future<String?> getSymbols() async {
    _setState = BinanceControllerState.gettingSymbols;
    final result = await _getSymbols(NoParams());

    if (result.$2 != null) {
      _resetState();
      return result.$2?.msg;
    }

    _symbols = result.$1;
    if (_symbols.isNotEmpty) {
      _currentSymbol ??= _symbols[11];
    }
    _resetState();

    serviceLocator<LoggerService>().log(
      logType: LogType.debug,
      msg: "Symbols Length ===> ${_symbols.length}",
    );
    return null;
  }

  Future<String?> getCandles(
      {required SymbolResponse symbol, required String interval}) async {
    _setState = BinanceControllerState.gettingCandles;
    final result = await _getCandles(GetCandlesParams(
      symbol: symbol.symbol ?? "",
      interval: interval.toLowerCase(),
    ));

    if (result.$2 != null) {
      _resetState();
      return result.$2?.msg;
    }

    _candles = result.$1;
    _resetState();

    serviceLocator<LoggerService>().log(
      logType: LogType.debug,
      msg: "Candles Length :: ${_candles.length}",
    );
    return null;
  }

  Future<String?> loadMoreCandles({
    required SymbolResponse symbol,
    required String interval,
  }) async {
    _setState = BinanceControllerState.gettingCandles;

    final result = await _getCandles(GetCandlesParams(
      symbol: symbol.symbol ?? "",
      interval: interval,
      endTIme: _candles.last.date.millisecondsSinceEpoch,
    ));

    if (result.$2 != null) {
      _resetState();
      return result.$2?.msg;
    }

    _candles
      ..removeLast()
      ..addAll(result.$1);
    _resetState();
    return null;
  }

  Future<String?> initializeWebSocket({
    required String symbol,
    required String interval,
  }) async {
    final result =
        await _establishSocketConnection(EstablishSocketConnectionParams(
      interval: interval.toLowerCase(),
      symbol: symbol.toLowerCase(),
    ));
    final chn = result.$1;

    if (result.$2 != null || chn == null) {
      _resetState();
      return result.$2?.msg;
    }

    await for (final String value in chn.stream) {
      serviceLocator<LoggerService>().log(
        logType: LogType.debug,
        msg: value,
      );
      final map = jsonDecode(value) as Map<String, dynamic>;
      final eventType = map['e'];

      // check if KLINE
      if (eventType == 'kline') {
        final candleTicker = CandleTickerDataModel.fromJson(map);
        _setCandleTicker = candleTicker;

        if (_candles[0].date == candleTicker.candle.date &&
            _candles[0].open == candleTicker.candle.open) {
          _candles[0] = candleTicker.candle;
          notifyListeners();
        } else if (candleTicker.candle.date.difference(_candles[0].date) ==
            _candles[0].date.difference(_candles[1].date)) {
          _candles.insert(0, candleTicker.candle);
          notifyListeners();
        }
      } else if (eventType == 'depthUpdate') {
        final orderBookInfo = OrderBookModel.fromMap(map);
        _setOrderBook = orderBookInfo;
      }
    }
    return null;
  }
}

enum BinanceControllerState {
  initial,
  gettingSymbols,
  gettingCandles,
  establishingConnection,
  ;
}
