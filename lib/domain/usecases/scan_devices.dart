import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/ble_device.dart';
import '../repositories/ble_repository.dart';

class ScanDevicesUseCase implements StreamUseCase<List<BleDevice>, NoParams> {
  final BleRepository repository;

  ScanDevicesUseCase(this.repository);

  @override
  Stream<Either<Failure, List<BleDevice>>> call(NoParams params) {
    return repository.scanForDevices();
  }
}
