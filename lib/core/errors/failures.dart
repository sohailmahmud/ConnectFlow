import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

class BleFailure extends Failure {
  final String message;

  const BleFailure(this.message);

  @override
  List<Object> get props => [message];
}

class DeviceNotFoundFailure extends Failure {}

class ConnectionFailure extends Failure {}

class DataTransferFailure extends Failure {}

class OtaUpdateFailure extends Failure {
  final String reason;

  const OtaUpdateFailure(this.reason);

  @override
  List<Object> get props => [reason];
}
