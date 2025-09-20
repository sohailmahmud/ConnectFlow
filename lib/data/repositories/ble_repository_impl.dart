import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/entities/sensor_data.dart';
import '../../domain/entities/ota_progress.dart';
import '../../domain/repositories/ble_repository.dart';
import '../datasources/ble_datasource.dart';

class BleRepositoryImpl implements BleRepository {
  final BleDataSource dataSource;
  
  BleRepositoryImpl(this.dataSource);
  
  @override
  Stream<Either<Failure, List<BleDevice>>> scanForDevices() async* {
    try {
      await for (final devices in dataSource.scanForDevices()) {
        yield Right(devices);
      }
    } catch (e) {
      yield Left(BleFailure('Failed to scan for devices: $e'));
    }
  }
  
  @override
  Future<Either<Failure, BleDevice>> connectToDevice(String deviceId) async {
    try {
      final device = await dataSource.connectToDevice(deviceId);
      return Right(device);
    } catch (e) {
      return Left(ConnectionFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> disconnectFromDevice(String deviceId) async {
    try {
      await dataSource.disconnectFromDevice(deviceId);
      return const Right(null);
    } catch (e) {
      return Left(BleFailure('Failed to disconnect: $e'));
    }
  }
  
  @override
  Stream<Either<Failure, SensorData>> streamSensorData(String deviceId) async* {
    try {
      // await for (final data in dataSource.streamSensorData(deviceId)) {
      //   yield Right(data);
      // }
    } catch (e) {
      yield Left(DataTransferFailure());
    }
  }
  
  @override
  Stream<Either<Failure, OtaProgress>> updateFirmware(String deviceId, List<int> firmwareData) async* {
    try {
      // await for (final progress in dataSource.updateFirmware(deviceId, firmwareData)) {
      //   yield Right(progress);
      // }
    } catch (e) {
      yield Left(OtaUpdateFailure('Firmware update failed: $e'));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isBluetoothEnabled() async {
    try {
      final isEnabled = await dataSource.isBluetoothEnabled();
      return Right(isEnabled);
    } catch (e) {
      return Left(BleFailure('Failed to check Bluetooth status: $e'));
    }
  }
  
  @override
  Future<Either<Failure, void>> enableBluetooth() async {
    try {
      await dataSource.enableBluetooth();
      return const Right(null);
    } catch (e) {
      return Left(BleFailure('Failed to enable Bluetooth: $e'));
    }
  }
}