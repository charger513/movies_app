import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class UnauthenticatedFailure extends Failure {}

class NotFoundFailure extends Failure {}

class UnknownFailure extends Failure {}
