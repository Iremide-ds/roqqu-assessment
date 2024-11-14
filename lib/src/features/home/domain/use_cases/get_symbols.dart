import 'package:roqqu_assessment/src/core/interfaces/use_cases.dart';
import 'package:roqqu_assessment/src/features/home/domain/entities/symbol.dart';
import 'package:roqqu_assessment/src/features/home/domain/repository/binance_repository.dart';

class GetSymbols implements UseCase<List<SymbolResponse>, NoParams> {
  final BinanceRepository _repository;

  const GetSymbols({required BinanceRepository repository})
      : _repository = repository;

  @override
  call(NoParams params) async {
    final result = await _repository.getSymbols();
    return (result.$1 ?? [], result.$2);
  }
}
