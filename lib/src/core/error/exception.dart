final class AppException implements Exception {
  final Object error;
  final StackTrace t;

  const AppException({required this.error, required this.t});
}

final class BinanceException implements Exception {
  final Object error;
  final StackTrace t;

  const BinanceException({required this.error, required this.t});
}
