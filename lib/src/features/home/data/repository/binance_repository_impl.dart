import 'dart:async';

import 'package:roqqu_assessment/src/core/common/util/logger.dart';
import 'package:roqqu_assessment/src/core/error/exception.dart';
import 'package:roqqu_assessment/src/core/error/failure.dart';
import 'package:roqqu_assessment/src/dependencies/init_dependencies.dart';
import 'package:roqqu_assessment/src/features/home/data/data_source/remote/binance_remote_data_source.dart';
import 'package:roqqu_assessment/src/features/home/domain/repository/binance_repository.dart';

class BinanceRepositoryImpl implements BinanceRepository {
  final BinanceRemoteDataSource _dataSource;

  const BinanceRepositoryImpl({required BinanceRemoteDataSource dataSource})
      : _dataSource = dataSource;

  FutureOr<(T?, Failure?)> _runFn<T>(FutureOr<T> Function() fn) async {
    try {
      final result = await fn();
      return (result, null);
    } on AppException catch (_) {
      return (null, const WebsocketFailure());
    } on BinanceException catch (_) {
      return (null, const BinanceFailure());
    } catch (e, t) {
      serviceLocator<LoggerService>().log(
        logType: LogType.error,
        error: e,
        stackTrace: t,
      );
      return (null, const UnexcepectedFailure());
    }
  }

  @override
  establishSocketConnection(
      {required String symbol, required String interval}) async {
    return await _runFn(() async {
      return _dataSource.establishSocketConnection(
        symbol: symbol,
        interval: interval,
      );
    });
  }

  @override
  getCandles({
    required String symbol,
    required String interval,
    int? endTime,
  }) async {
    return await _runFn(() async {
      return await _dataSource.getCandles(
        symbol: symbol,
        interval: interval,
        endTime: endTime,
      );
    });
  }

  @override
  getSymbols() async {
    return await _runFn(() async {
      return await _dataSource.getSymbols();
    });
  }
}
