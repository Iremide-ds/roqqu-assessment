import 'package:candlesticks/candlesticks.dart';
import 'package:roqqu_assessment/src/core/interfaces/use_cases.dart';
import 'package:roqqu_assessment/src/features/home/domain/repository/binance_repository.dart';

class GetCandles implements UseCase<List<Candle>, GetCandlesParams> {
  final BinanceRepository _repository;

  const GetCandles({required BinanceRepository repository})
      : _repository = repository;

  @override
  call(params) async {
    final result = await _repository.getCandles(
      interval: params.interval,
      symbol: params.symbol,
      endTime: params.endTIme,
    );
    return (result.$1 ?? [], result.$2);
  }
}

class GetCandlesParams {
  final String symbol;
  final String interval;
  final int? endTIme;

  const GetCandlesParams({
    required this.symbol,
    required this.interval,
    this.endTIme,
  });
}
