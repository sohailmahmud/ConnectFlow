import 'package:equatable/equatable.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/entities/sensor_data.dart';
import '../../domain/entities/ota_progress.dart';

abstract class BleState extends Equatable {
  const BleState();
  
  @override
  List<Object?> get props => [];
}

class BleInitial extends BleState {}

class BleScanning extends BleState {}

class BleDevicesFound extends BleState {
  final List<BleDevice> devices;
  
  const BleDevicesFound(this.devices);
  
  @override
  List<Object> get props => [devices];
}

class BleConnecting extends BleState {
  final String deviceId;
  
  const BleConnecting(this.deviceId);
  
  @override
  List<Object> get props => [deviceId];
}

class BleConnected extends BleState {
  final BleDevice device;
  
  const BleConnected(this.device);
  
  @override
  List<Object> get props => [device];
}

class BleDataStreaming extends BleState {
  final BleDevice device;
  final List<SensorData> dataHistory;
  
  const BleDataStreaming(this.device, this.dataHistory);
  
  @override
  List<Object> get props => [device, dataHistory];
}

class BleOtaUpdating extends BleState {
  final BleDevice device;
  final OtaProgress progress;
  
  const BleOtaUpdating(this.device, this.progress);
  
  @override
  List<Object> get props => [device, progress];
}

class BleError extends BleState {
  final String message;
  
  const BleError(this.message);
  
  @override
  List<Object> get props => [message];
}