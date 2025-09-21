import 'package:equatable/equatable.dart';

abstract class BleEvent extends Equatable {
  const BleEvent();

  @override
  List<Object> get props => [];
}

class StartScanningEvent extends BleEvent {}

class StopScanningEvent extends BleEvent {}

class ConnectToDeviceEvent extends BleEvent {
  final String deviceId;

  const ConnectToDeviceEvent(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class DisconnectFromDeviceEvent extends BleEvent {
  final String deviceId;

  const DisconnectFromDeviceEvent(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class StartDataStreamEvent extends BleEvent {
  final String deviceId;

  const StartDataStreamEvent(this.deviceId);

  @override
  List<Object> get props => [deviceId];
}

class StopDataStreamEvent extends BleEvent {}

class StartFirmwareUpdateEvent extends BleEvent {
  final String deviceId;
  final List<int> firmwareData;

  const StartFirmwareUpdateEvent(this.deviceId, this.firmwareData);

  @override
  List<Object> get props => [deviceId, firmwareData];
}
