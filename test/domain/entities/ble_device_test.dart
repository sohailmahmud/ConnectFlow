import 'package:connectflow/domain/entities/ble_device.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BleDevice', () {
    test('should create BleDevice with all properties', () {
      // Arrange
      const device = BleDevice(
        id: 'test-id',
        name: 'Test Device',
        rssi: -50,
        isConnected: true,
        advertisementData: {'key': 'value'},
      );

      // Assert
      expect(device.id, 'test-id');
      expect(device.name, 'Test Device');
      expect(device.rssi, -50);
      expect(device.isConnected, true);
      expect(device.advertisementData, {'key': 'value'});
    });

    test('should support value equality', () {
      // Arrange
      const device1 = BleDevice(
        id: 'test-id',
        name: 'Test Device',
        rssi: -50,
        isConnected: true,
        advertisementData: {},
      );

      const device2 = BleDevice(
        id: 'test-id',
        name: 'Test Device',
        rssi: -50,
        isConnected: true,
        advertisementData: {},
      );

      // Assert
      expect(device1, device2);
      expect(device1.hashCode, device2.hashCode);
    });

    test('should create copy with updated properties', () {
      // Arrange
      const originalDevice = BleDevice(
        id: 'test-id',
        name: 'Test Device',
        rssi: -50,
        isConnected: false,
        advertisementData: {},
      );

      // Act
      final updatedDevice = originalDevice.copyWith(
        isConnected: true,
        rssi: -40,
      );

      // Assert
      expect(updatedDevice.id, originalDevice.id);
      expect(updatedDevice.name, originalDevice.name);
      expect(updatedDevice.isConnected, true);
      expect(updatedDevice.rssi, -40);
    });
  });
}