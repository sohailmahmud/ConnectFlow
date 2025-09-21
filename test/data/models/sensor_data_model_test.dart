import 'dart:convert';
import 'package:connectflow/data/models/sensor_data_model.dart';
import 'package:connectflow/domain/entities/sensor_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTimestamp = DateTime.parse('2024-01-01T12:00:00.000Z');
  final tSensorDataModel = SensorDataModel(
    timestamp: tTimestamp,
    temperature: 25.5,
    humidity: 60.0,
    pressure: 1013.25,
    batteryLevel: 85,
  );

  group('SensorDataModel', () {
    test('should be a subclass of SensorData entity', () {
      // Assert
      expect(tSensorDataModel, isA<SensorData>());
    });

    group('fromJson', () {
      test('should return a valid model when JSON is valid', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'timestamp': '2024-01-01T12:00:00.000Z',
          'temperature': 25.5,
          'humidity': 60.0,
          'pressure': 1013.25,
          'batteryLevel': 85,
        };

        // Act
        final result = SensorDataModel.fromJson(jsonMap);

        // Assert
        expect(result, tSensorDataModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tSensorDataModel.toJson();

        // Assert
        final expectedMap = {
          'timestamp': '2024-01-01T12:00:00.000Z',
          'temperature': 25.5,
          'humidity': 60.0,
          'pressure': 1013.25,
          'batteryLevel': 85,
        };
        expect(result, expectedMap);
      });
    });

    group('JSON serialization', () {
      test(
        'should maintain data integrity through serialize/deserialize cycle',
        () {
          // Arrange
          final jsonString = json.encode(tSensorDataModel.toJson());

          // Act
          final jsonMap = json.decode(jsonString);
          final result = SensorDataModel.fromJson(jsonMap);

          // Assert
          expect(result, tSensorDataModel);
        },
      );
    });
  });
}
