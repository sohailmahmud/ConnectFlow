import 'package:connectflow/core/errors/failures.dart';
import 'package:connectflow/domain/entities/ble_device.dart';
import 'package:connectflow/domain/repositories/ble_repository.dart';
import 'package:connectflow/domain/usecases/connect_device.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBleRepository extends Mock implements BleRepository {}

void main() {
  late ConnectDeviceUseCase usecase;
  late MockBleRepository mockBleRepository;

  setUp(() {
    mockBleRepository = MockBleRepository();
    usecase = ConnectDeviceUseCase(mockBleRepository);
  });

  group('ConnectDeviceUseCase', () {
    const tDeviceId = 'test-device-id';
    const tConnectedDevice = BleDevice(
      id: tDeviceId,
      name: 'Test Device',
      rssi: -50,
      isConnected: true,
      advertisementData: {},
    );

    test('should return connected device when connection succeeds', () async {
      // Arrange
      when(() => mockBleRepository.connectToDevice(tDeviceId))
          .thenAnswer((_) async => const Right(tConnectedDevice));

      // Act
      final result = await usecase(tDeviceId);

      // Assert
      expect(result, const Right(tConnectedDevice));
      verify(() => mockBleRepository.connectToDevice(tDeviceId)).called(1);
    });

    test('should return failure when connection fails', () async {
      // Arrange
      final tFailure = ConnectionFailure();
      when(() => mockBleRepository.connectToDevice(tDeviceId))
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase(tDeviceId);

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockBleRepository.connectToDevice(tDeviceId)).called(1);
    });
  });
}
