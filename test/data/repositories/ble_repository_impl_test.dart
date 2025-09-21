import 'package:connectflow/core/errors/failures.dart';
import 'package:connectflow/data/datasources/ble_datasource.dart';
import 'package:connectflow/data/models/ble_device_model.dart';
import 'package:connectflow/data/repositories/ble_repository_impl.dart';
import 'package:connectflow/domain/entities/ble_device.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBleDataSource extends Mock implements BleDataSource {}

void main() {
  late BleRepositoryImpl repository;
  late MockBleDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockBleDataSource();
    repository = BleRepositoryImpl(mockDataSource);
  });

  group('BleRepositoryImpl', () {
    const tDeviceId = 'test-device-id';
    const tDeviceModel = BleDeviceModel(
      id: tDeviceId,
      name: 'Test Device',
      rssi: -50,
      isConnected: false,
      advertisementData: {},
    );

    group('scanForDevices', () {
      test('should return device list when datasource succeeds', () async {
        // Arrange
        when(() => mockDataSource.scanForDevices())
            .thenAnswer((_) => Stream.value([tDeviceModel]));

        // Act
        final result = repository.scanForDevices();

        // Assert
        final events = <Either<Failure, List<BleDevice>>>[];
        await for (final event in result) {
          events.add(event);
          break; // Only take the first event
        }
        
        expect(events.length, 1);
        expect(events.first.isRight(), true);
        events.first.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (devices) => expect(devices, [tDeviceModel]),
        );
        verify(() => mockDataSource.scanForDevices()).called(1);
      });

      test('should return failure when datasource throws exception', () async {
        // Arrange
        when(() => mockDataSource.scanForDevices())
            .thenAnswer((_) => Stream.error(Exception('Scan failed')));

        // Act
        final result = repository.scanForDevices();

        // Assert
        await expectLater(
          result,
          emits(isA<Left<Failure, List<dynamic>>>()),
        );
      });
    });

    group('connectToDevice', () {
      const tConnectedDeviceModel = BleDeviceModel(
        id: tDeviceId,
        name: 'Test Device',
        rssi: -50,
        isConnected: true,
        advertisementData: {},
      );

      test('should return connected device when datasource succeeds', () async {
        // Arrange
        when(() => mockDataSource.connectToDevice(tDeviceId))
            .thenAnswer((_) async => tConnectedDeviceModel);

        // Act
        final result = await repository.connectToDevice(tDeviceId);

        // Assert
        expect(result, const Right(tConnectedDeviceModel));
        verify(() => mockDataSource.connectToDevice(tDeviceId)).called(1);
      });

      test('should return failure when datasource throws exception', () async {
        // Arrange
        when(() => mockDataSource.connectToDevice(tDeviceId))
            .thenThrow(Exception('Connection failed'));

        // Act
        final result = await repository.connectToDevice(tDeviceId);

        // Assert
        expect(result, isA<Left<Failure, dynamic>>());
        verify(() => mockDataSource.connectToDevice(tDeviceId)).called(1);
      });
    });
  });
}
