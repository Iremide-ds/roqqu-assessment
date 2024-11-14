abstract class Failure {
  final String msg;

  const Failure({this.msg = "An error occurred"});
}

final class UnexcepectedFailure extends Failure {
  const UnexcepectedFailure({super.msg});
}

final class BinanceFailure extends Failure {
  const BinanceFailure({super.msg});
}

final class WebsocketFailure extends Failure {
  const WebsocketFailure({super.msg});
}
