import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/entities/sensor_data.dart';
import '../../domain/usecases/scan_devices.dart';
import 'ble_event.dart';
import 'ble_state.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final ScanDevicesUseCase scanDevicesUseCase;
  //final ConnectDeviceUseCase connectDeviceUseCase;
  // final StreamDataUseCase streamDataUseCase;
  // final UpdateFirmwareUseCase updateFirmwareUseCase;
  
  StreamSubscription? _scanSubscription;
  StreamSubscription? _dataSubscription;
  StreamSubscription? _otaSubscription;
  
  final List<SensorData> _dataHistory = [];
  BleDevice? _connectedDevice;
  
  BleBloc({
    required this.scanDevicesUseCase,
    //required this.connectDeviceUseCase,
    // required this.streamDataUseCase,
    // required this.updateFirmwareUseCase,
  }) : super(BleInitial()) {
    on<StartScanningEvent>(_onStartScanning);
    on<StopScanningEvent>(_onStopScanning);
    on<ConnectToDeviceEvent>(_onConnectToDevice);
    on<DisconnectFromDeviceEvent>(_onDisconnectFromDevice);
    on<StartDataStreamEvent>(_onStartDataStream);
    on<StopDataStreamEvent>(_onStopDataStream);
    on<StartFirmwareUpdateEvent>(_onStartFirmwareUpdate);
  }
  
  Future<void> _onStartScanning(StartScanningEvent event, Emitter<BleState> emit) async {
    emit(BleScanning());
    
    _scanSubscription?.cancel();
    _scanSubscription = scanDevicesUseCase(const NoParams()).listen(
      (result) {
        result.fold(
          (failure) => emit(BleError(failure.toString())),
          (devices) => emit(BleDevicesFound(devices)),
        );
      },
    );
  }
  
  Future<void> _onStopScanning(StopScanningEvent event, Emitter<BleState> emit) async {
    await _scanSubscription?.cancel();
    _scanSubscription = null;
  }
  
  Future<void> _onConnectToDevice(ConnectToDeviceEvent event, Emitter<BleState> emit) async {
    emit(BleConnecting(event.deviceId));
    
    // final result = await connectDeviceUseCase(event.deviceId);
    // result.fold(
    //   (failure) => emit(BleError('Connection failed: ${failure.toString()}')),
    //   (device) {
    //     _connectedDevice = device;
    //     emit(BleConnected(device));
    //   },
    // );
  }
  
  Future<void> _onDisconnectFromDevice(DisconnectFromDeviceEvent event, Emitter<BleState> emit) async {
    await _dataSubscription?.cancel();
    _dataSubscription = null;
    _connectedDevice = null;
    _dataHistory.clear();
    emit(BleInitial());
  }
  
  Future<void> _onStartDataStream(StartDataStreamEvent event, Emitter<BleState> emit) async {
    if (_connectedDevice == null) {
      emit(const BleError('No device connected'));
      return;
    }
    
    _dataSubscription?.cancel();
    // _dataSubscription = streamDataUseCase(event.deviceId).listen(
    //   (result) {
    //     result.fold(
    //       (failure) => emit(BleError('Data streaming failed: ${failure.toString()}')),
    //       (data) {
    //         _dataHistory.add(data);
    //         // Keep only last 100 readings
    //         if (_dataHistory.length > 100) {
    //           _dataHistory.removeAt(0);
    //         }
    //         emit(BleDataStreaming(_connectedDevice!, List.from(_dataHistory)));
    //       },
    //     );
    //   },
    // );
  }
  
  Future<void> _onStopDataStream(StopDataStreamEvent event, Emitter<BleState> emit) async {
    await _dataSubscription?.cancel();
    _dataSubscription = null;
    
    if (_connectedDevice != null) {
      emit(BleConnected(_connectedDevice!));
    }
  }
  
  Future<void> _onStartFirmwareUpdate(StartFirmwareUpdateEvent event, Emitter<BleState> emit) async {
    if (_connectedDevice == null) {
      emit(const BleError('No device connected'));
      return;
    }
    
    // final params = UpdateFirmwareParams(
    //   deviceId: event.deviceId,
    //   firmwareData: event.firmwareData,
    // );
    
    _otaSubscription?.cancel();
    // _otaSubscription = updateFirmwareUseCase(params).listen(
    //   (result) {
    //     result.fold(
    //       (failure) => emit(BleError('OTA update failed: ${failure.toString()}')),
    //       (progress) => emit(BleOtaUpdating(_connectedDevice!, progress)),
    //     );
    //   },
    // );
  }
  
  @override
  Future<void> close() {
    _scanSubscription?.cancel();
    _dataSubscription?.cancel();
    _otaSubscription?.cancel();
    return super.close();
  }
}