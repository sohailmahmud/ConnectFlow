import 'package:equatable/equatable.dart';

class BleDevice extends Equatable {
  final String id;
  final String name;
  final int rssi;
  final bool isConnected;
  final Map<String, dynamic> advertisementData;

  const BleDevice({
    required this.id,
    required this.name,
    required this.rssi,
    required this.isConnected,
    required this.advertisementData,
  });

  BleDevice copyWith({
    String? id,
    String? name,
    int? rssi,
    bool? isConnected,
    Map<String, dynamic>? advertisementData,
  }) {
    return BleDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      rssi: rssi ?? this.rssi,
      isConnected: isConnected ?? this.isConnected,
      advertisementData: advertisementData ?? this.advertisementData,
    );
  }

  @override
  List<Object?> get props => [id, name, rssi, isConnected, advertisementData];
}
