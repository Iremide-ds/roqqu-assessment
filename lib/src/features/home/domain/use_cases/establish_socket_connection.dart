import 'package:roqqu_assessment/src/core/interfaces/use_cases.dart';
import 'package:roqqu_assessment/src/features/home/domain/repository/binance_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class EstablishSocketConnection
    implements UseCase<WebSocketChannel?, EstablishSocketConnectionParams> {
  final BinanceRepository _repository;

  const EstablishSocketConnection({required BinanceRepository repository})
      : _repository = repository;

  @override
  call(params) async {
    return await _repository.establishSocketConnection(
      interval: params.interval,
      symbol: params.symbol,
    );
  }
}

class EstablishSocketConnectionParams {
  final String interval;
  final String symbol;

  const EstablishSocketConnectionParams({
    required this.interval,
    required this.symbol,
  });
}
