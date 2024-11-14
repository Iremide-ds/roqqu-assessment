import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerService {
  final Logger _logger;
  LoggerService() : _logger = Logger(filter: _LoggingFilter());

  void log(
      {required LogType logType,
      String? msg,
      Object? error,
      StackTrace? stackTrace}) {
    if (!kDebugMode) return;

    msg ??= "$this";
    switch (logType) {
      case LogType.debug:
        _logger.d(msg, error: error, stackTrace: stackTrace);
        break;
      case LogType.info:
        _logger.i(msg, error: error, stackTrace: stackTrace);
        break;
      case LogType.error:
        _logger.e(msg, error: error, stackTrace: stackTrace);
        break;
      case LogType.fatal:
        _logger.f(msg, error: error, stackTrace: stackTrace);
        break;
      case LogType.trace:
        _logger.t(msg, error: error, stackTrace: stackTrace);
        break;
    }
  }
}

class _LoggingFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode;
  }
}

enum LogType {
  debug,
  info,
  error,
  fatal,
  trace;
}
