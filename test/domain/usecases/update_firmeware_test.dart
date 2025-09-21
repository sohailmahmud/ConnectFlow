import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectflow/core/errors/failures.dart';
import 'package:connectflow/domain/entities/ota_progress.dart';
import 'package:connectflow/domain/repositories/ble_repository.dart';
import 'package:connectflow/domain/usecases/update_firmware.dart';

class MockBleRepository extends Mock implements BleRepository {}

void main() {
  late UpdateFirmwareUseCase usecase;
  late MockBleRepository mockBleRepository;

  setUp(() {
    mockBleRepository = MockBleRepository();
    usecase = UpdateFirmwareUseCase(mockBleRepository);
  });

  group('UpdateFirmwareUseCase', () {
    const tDeviceId = 'test-device-id';
    final tFirmwareData = List.generate(100, (i) => i);
    final tParams = UpdateFirmwareParams(
      deviceId: tDeviceId,
      firmwareData: tFirmwareData,
    );

    test('should return progress stream from repository', () async {
      // Arrange
      const tProgress = OtaProgress(
        status: OtaStatus.transferring,
        progress: 0.5,
        message: 'Transferring...',
      );

      when(
        () => mockBleRepository.updateFirmware(tDeviceId, tFirmwareData),
      ).thenAnswer((_) => Stream.value(const Right(tProgress)));

      // Act
      final result = usecase(tParams);

      // Assert
      await expectLater(result, emits(const Right(tProgress)));
      verify(
        () => mockBleRepository.updateFirmware(tDeviceId, tFirmwareData),
      ).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const tFailure = OtaUpdateFailure('Update failed');
      when(
        () => mockBleRepository.updateFirmware(tDeviceId, tFirmwareData),
      ).thenAnswer((_) => Stream.value(const Left(tFailure)));

      // Act
      final result = usecase(tParams);

      // Assert
      await expectLater(result, emits(const Left(tFailure)));
    });

    test('should handle complete update progress sequence', () async {
      // Arrange
      const progressSequence = [
        OtaProgress(status: OtaStatus.preparing, progress: 0.0),
        OtaProgress(status: OtaStatus.transferring, progress: 0.5),
        OtaProgress(status: OtaStatus.verifying, progress: 0.9),
        OtaProgress(status: OtaStatus.completed, progress: 1.0),
      ];

      when(
        () => mockBleRepository.updateFirmware(tDeviceId, tFirmwareData),
      ).thenAnswer(
        (_) => Stream.fromIterable(progressSequence.map((p) => Right(p))),
      );

      // Act
      final result = usecase(tParams);

      // Assert
      await expectLater(
        result,
        emitsInOrder(progressSequence.map((p) => Right(p))),
      );
    });
  });
}
