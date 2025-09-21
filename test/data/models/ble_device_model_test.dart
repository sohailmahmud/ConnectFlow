import 'dart:convert';
import 'package:connectflow/data/models/ble_device_model.dart';
import 'package:connectflow/domain/entities/ble_device.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tBleDeviceModel = BleDeviceModel(
    id: 'test-id',
    name: 'Test Device',
    rssi: -50,
    isConnected: true,
    advertisementData: {'key': 'value'},
  );

  group('BleDeviceModel', () {
    test('should be a subclass of BleDevice entity', () {
      // Assert
      expect(tBleDeviceModel, isA<BleDevice>());
    });

    group('fromJson', () {
      test('should return a valid model when JSON is valid', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 'test-id',
          'name': 'Test Device',
          'rssi': -50,
          'isConnected': true,
          'advertisementData': {'key': 'value'},
        };

        // Act
        final result = BleDeviceModel.fromJson(jsonMap);

        // Assert
        expect(result, tBleDeviceModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tBleDeviceModel.toJson();

        // Assert
        final expectedMap = {
          'id': 'test-id',
          'name': 'Test Device',
          'rssi': -50,
          'isConnected': true,
          'advertisementData': {'key': 'value'},
        };
        expect(result, expectedMap);
      });
    });

    group('JSON serialization', () {
      test(
        'should maintain data integrity through serialize/deserialize cycle',
        () {
          // Arrange
          final jsonString = json.encode(tBleDeviceModel.toJson());

          // Act
          final jsonMap = json.decode(jsonString);
          final result = BleDeviceModel.fromJson(jsonMap);

          // Assert
          expect(result, tBleDeviceModel);
        },
      );
    });
  });
}
