import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/sensor_data.dart';
import '../repositories/ble_repository.dart';

class StreamDataUseCase implements StreamUseCase<SensorData, String> {
  final BleRepository repository;

  StreamDataUseCase(this.repository);

  @override
  Stream<Either<Failure, SensorData>> call(String deviceId) {
    return repository.streamSensorData(deviceId);
  }
}
