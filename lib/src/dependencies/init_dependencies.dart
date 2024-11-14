import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:roqqu_assessment/src/core/common/util/logger.dart';
import 'package:roqqu_assessment/src/features/home/data/data_source/remote/binance_remote_data_source.dart';
import 'package:roqqu_assessment/src/features/home/data/repository/binance_repository_impl.dart';
import 'package:roqqu_assessment/src/features/home/domain/repository/binance_repository.dart';
import 'package:roqqu_assessment/src/features/home/domain/use_cases/establish_socket_connection.dart';
import 'package:roqqu_assessment/src/features/home/domain/use_cases/get_candles.dart';
import 'package:roqqu_assessment/src/features/home/domain/use_cases/get_symbols.dart';
import 'package:roqqu_assessment/src/features/home/presentation/controller/binance_controller.dart';

final serviceLocator = GetIt.instance;

void initDependencies() {
  _initLogger();
  _initDio();
  _initHomeController();
}

void _initLogger() {
  serviceLocator.registerLazySingleton(() {
    return LoggerService();
  });
}

void _initDio() {
  final dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
    ));
  serviceLocator.registerLazySingleton(() {
    return dio;
  });
}

void _initHomeController() {
  serviceLocator
    ..registerLazySingleton<BinanceRemoteDataSource>(() {
      return BinanceRemoteDataSourceImpl(restClient: serviceLocator());
    })
    ..registerLazySingleton<BinanceRepository>(() {
      return BinanceRepositoryImpl(dataSource: serviceLocator());
    })
    ..registerFactory(() {
      return GetSymbols(repository: serviceLocator());
    })
    ..registerFactory(() {
      return GetCandles(repository: serviceLocator());
    })
    ..registerFactory(() {
      return EstablishSocketConnection(repository: serviceLocator());
    })
    ..registerLazySingleton(() {
      return BinanceController(
        getSymbols: serviceLocator(),
        getCandles: serviceLocator(),
        establishSocketConnection: serviceLocator(),
      );
    });
}
