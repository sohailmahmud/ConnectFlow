import 'package:connectflow/core/errors/failures.dart';
import 'package:connectflow/core/usecases/usecase.dart';
import 'package:connectflow/domain/entities/ble_device.dart';
import 'package:connectflow/domain/repositories/ble_repository.dart';
import 'package:connectflow/domain/usecases/scan_devices.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBleRepository extends Mock implements BleRepository {}

void main() {
  late ScanDevicesUseCase usecase;
  late MockBleRepository mockBleRepository;

  setUp(() {
    mockBleRepository = MockBleRepository();
    usecase = ScanDevicesUseCase(mockBleRepository);
  });

  group('ScanDevicesUseCase', () {
    const tDevices = [
      BleDevice(
        id: 'device-1',
        name: 'Test Device 1',
        rssi: -50,
        isConnected: false,
        advertisementData: {},
      ),
      BleDevice(
        id: 'device-2',
        name: 'Test Device 2',
        rssi: -60,
        isConnected: false,
        advertisementData: {},
      ),
    ];

    test('should return stream of device lists from repository', () async {
      // Arrange
      when(
        () => mockBleRepository.scanForDevices(),
      ).thenAnswer((_) => Stream.value(const Right(tDevices)));

      // Act
      final result = usecase(const NoParams());

      // Assert
      await expectLater(result, emits(const Right(tDevices)));
      verify(() => mockBleRepository.scanForDevices()).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const tFailure = BleFailure('Scan failed');
      when(
        () => mockBleRepository.scanForDevices(),
      ).thenAnswer((_) => Stream.value(const Left(tFailure)));

      // Act
      final result = usecase(const NoParams());

      // Assert
      await expectLater(result, emits(const Left(tFailure)));
      verify(() => mockBleRepository.scanForDevices()).called(1);
    });
  });
}
