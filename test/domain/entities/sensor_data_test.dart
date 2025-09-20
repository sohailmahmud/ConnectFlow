import 'package:connectflow/domain/entities/sensor_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SensorData', () {
    test('should create SensorData with all properties', () {
      // Arrange
      final timestamp = DateTime.now();
      const temperature = 25.5;
      const humidity = 60.0;
      const pressure = 1013.25;
      const batteryLevel = 85;

      // Act
      final sensorData = SensorData(
        timestamp: timestamp,
        temperature: temperature,
        humidity: humidity,
        pressure: pressure,
        batteryLevel: batteryLevel,
      );

      // Assert
      expect(sensorData.timestamp, timestamp);
      expect(sensorData.temperature, temperature);
      expect(sensorData.humidity, humidity);
      expect(sensorData.pressure, pressure);
      expect(sensorData.batteryLevel, batteryLevel);
    });

    test('should support value equality', () {
      // Arrange
      final timestamp = DateTime.now();
      final sensorData1 = SensorData(
        timestamp: timestamp,
        temperature: 25.5,
        humidity: 60.0,
        pressure: 1013.25,
        batteryLevel: 85,
      );

      final sensorData2 = SensorData(
        timestamp: timestamp,
        temperature: 25.5,
        humidity: 60.0,
        pressure: 1013.25,
        batteryLevel: 85,
      );

      // Assert
      expect(sensorData1, sensorData2);
      expect(sensorData1.hashCode, sensorData2.hashCode);
    });
  });
}