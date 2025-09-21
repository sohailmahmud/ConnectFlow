import 'package:flutter_test/flutter_test.dart';
import 'package:connectflow/core/errors/failures.dart';

void main() {
  group('Failures', () {
    group('BleFailure', () {
      test('should support value equality', () {
        // Arrange
        const failure1 = BleFailure('Test error');
        const failure2 = BleFailure('Test error');
        const failure3 = BleFailure('Different error');

        // Assert
        expect(failure1, failure2);
        expect(failure1.hashCode, failure2.hashCode);
        expect(failure1, isNot(failure3));
      });

      test('should have correct message', () {
        // Arrange
        const failure = BleFailure('Test error message');

        // Assert
        expect(failure.message, 'Test error message');
      });
    });

    group('OtaUpdateFailure', () {
      test('should support value equality', () {
        // Arrange
        const failure1 = OtaUpdateFailure('Update failed');
        const failure2 = OtaUpdateFailure('Update failed');
        const failure3 = OtaUpdateFailure('Different failure');

        // Assert
        expect(failure1, failure2);
        expect(failure1.hashCode, failure2.hashCode);
        expect(failure1, isNot(failure3));
      });

      test('should have correct reason', () {
        // Arrange
        const failure = OtaUpdateFailure('Firmware corrupted');

        // Assert
        expect(failure.reason, 'Firmware corrupted');
      });
    });

    group('Other Failures', () {
      test('should create correct failure types', () {
        // Arrange & Act
        final deviceNotFound = DeviceNotFoundFailure();
        final connectionFailure = ConnectionFailure();
        final dataTransferFailure = DataTransferFailure();

        // Assert
        expect(deviceNotFound, isA<DeviceNotFoundFailure>());
        expect(connectionFailure, isA<ConnectionFailure>());
        expect(dataTransferFailure, isA<DataTransferFailure>());
      });

      test('should support equality for parameterless failures', () {
        // Arrange
        final failure1 = DeviceNotFoundFailure();
        final failure2 = DeviceNotFoundFailure();

        // Assert
        expect(failure1, failure2);
        expect(failure1.hashCode, failure2.hashCode);
      });
    });
  });
}