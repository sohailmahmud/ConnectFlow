import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

abstract class UseCase<TResult, Params> {
  Future<Either<Failure, TResult>> call(Params params);
}

abstract class StreamUseCase<TResult, Params> {
  Stream<Either<Failure, TResult>> call(Params params);
}

class NoParams {
  const NoParams();
}
