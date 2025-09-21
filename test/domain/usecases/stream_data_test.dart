import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectflow/core/errors/failures.dart';
import 'package:connectflow/domain/entities/sensor_data.dart';
import 'package:connectflow/domain/repositories/ble_repository.dart';
import 'package:connectflow/domain/usecases/stream_data.dart';

class MockBleRepository extends Mock implements BleRepository {}

void main() {
  late StreamDataUseCase usecase;
  late MockBleRepository mockBleRepository;

  setUp(() {
    mockBleRepository = MockBleRepository();
    usecase = StreamDataUseCase(mockBleRepository);
  });

  group('StreamDataUseCase', () {
    const tDeviceId = 'test-device-id';
    final tSensorData = SensorData(
      timestamp: DateTime.now(),
      temperature: 25.5,
      humidity: 60.0,
      pressure: 1013.25,
      batteryLevel: 85,
    );

    test('should return stream of sensor data from repository', () async {
      // Arrange
      when(
        () => mockBleRepository.streamSensorData(tDeviceId),
      ).thenAnswer((_) => Stream.value(Right(tSensorData)));

      // Act
      final result = usecase(tDeviceId);

      // Assert
      await expectLater(result, emits(Right(tSensorData)));
      verify(() => mockBleRepository.streamSensorData(tDeviceId)).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final tFailure = DataTransferFailure();
      when(
        () => mockBleRepository.streamSensorData(tDeviceId),
      ).thenAnswer((_) => Stream.value(Left(tFailure)));

      // Act
      final result = usecase(tDeviceId);

      // Assert
      await expectLater(result, emits(Left(tFailure)));
      verify(() => mockBleRepository.streamSensorData(tDeviceId)).called(1);
    });

    test('should handle multiple data points in stream', () async {
      // Arrange
      final tSensorData2 = SensorData(
        timestamp: DateTime.now().add(const Duration(seconds: 1)),
        temperature: 26.0,
        humidity: 61.0,
        pressure: 1014.0,
        batteryLevel: 84,
      );

      when(() => mockBleRepository.streamSensorData(tDeviceId)).thenAnswer(
        (_) => Stream.fromIterable([Right(tSensorData), Right(tSensorData2)]),
      );

      // Act
      final result = usecase(tDeviceId);

      // Assert
      await expectLater(
        result,
        emitsInOrder([Right(tSensorData), Right(tSensorData2)]),
      );
    });
  });
}
