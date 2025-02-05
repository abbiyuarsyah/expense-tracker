import 'package:dartz/dartz.dart';
import 'execptions.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
