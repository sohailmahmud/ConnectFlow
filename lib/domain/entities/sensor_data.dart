import 'package:equatable/equatable.dart';

class SensorData extends Equatable {
  final DateTime timestamp;
  final double temperature;
  final double humidity;
  final double pressure;
  final int batteryLevel;
  
  const SensorData({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.batteryLevel,
  });
  
  @override
  List<Object> get props => [timestamp, temperature, humidity, pressure, batteryLevel];
}