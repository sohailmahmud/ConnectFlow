import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/ota_progress.dart';
import '../repositories/ble_repository.dart';

class UpdateFirmwareParams {
  final String deviceId;
  final List<int> firmwareData;
  
  UpdateFirmwareParams({required this.deviceId, required this.firmwareData});
}

class UpdateFirmwareUseCase implements StreamUseCase<OtaProgress, UpdateFirmwareParams> {
  final BleRepository repository;
  
  UpdateFirmwareUseCase(this.repository);
  
  @override
  Stream<Either<Failure, OtaProgress>> call(UpdateFirmwareParams params) {
    return repository.updateFirmware(params.deviceId, params.firmwareData);
  }
}