import '../../domain/entities/sensor_data.dart';

class SensorDataModel extends SensorData {
  const SensorDataModel({
    required super.timestamp,
    required super.temperature,
    required super.humidity,
    required super.pressure,
    required super.batteryLevel,
  });
  
  factory SensorDataModel.fromJson(Map<String, dynamic> json) {
    return SensorDataModel(
      timestamp: DateTime.parse(json['timestamp']),
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
      pressure: json['pressure'].toDouble(),
      batteryLevel: json['batteryLevel'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'temperature': temperature,
      'humidity': humidity,
      'pressure': pressure,
      'batteryLevel': batteryLevel,
    };
  }
}