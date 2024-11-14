import 'package:roqqu_assessment/src/core/error/failure.dart';

abstract class UseCase<SuccessType, Params> {
  Future<(SuccessType, Failure?)> call(Params params);
}

class NoParams {}
