import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/ble_device.dart';
import '../entities/sensor_data.dart';
import '../entities/ota_progress.dart';

abstract class BleRepository {
  Stream<Either<Failure, List<BleDevice>>> scanForDevices();
  Future<Either<Failure, BleDevice>> connectToDevice(String deviceId);
  Future<Either<Failure, void>> disconnectFromDevice(String deviceId);
  Stream<Either<Failure, SensorData>> streamSensorData(String deviceId);
  Stream<Either<Failure, OtaProgress>> updateFirmware(
    String deviceId,
    List<int> firmwareData,
  );
  Future<Either<Failure, bool>> isBluetoothEnabled();
  Future<Either<Failure, void>> enableBluetooth();
}
