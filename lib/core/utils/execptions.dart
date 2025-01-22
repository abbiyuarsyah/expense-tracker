import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure() : super(tr('unexpected_error'));
}
