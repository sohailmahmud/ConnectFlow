import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/ble_device.dart';
import '../repositories/ble_repository.dart';

class ConnectDeviceUseCase implements UseCase<BleDevice, String> {
  final BleRepository repository;
  
  ConnectDeviceUseCase(this.repository);
  
  @override
  Future<Either<Failure, BleDevice>> call(String deviceId) {
    return repository.connectToDevice(deviceId);
  }
}
