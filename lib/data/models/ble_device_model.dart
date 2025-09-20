import '../../domain/entities/ble_device.dart';

class BleDeviceModel extends BleDevice {
  const BleDeviceModel({
    required super.id,
    required super.name,
    required super.rssi,
    required super.isConnected,
    required super.advertisementData,
  });
  
  factory BleDeviceModel.fromJson(Map<String, dynamic> json) {
    return BleDeviceModel(
      id: json['id'],
      name: json['name'],
      rssi: json['rssi'],
      isConnected: json['isConnected'],
      advertisementData: json['advertisementData'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rssi': rssi,
      'isConnected': isConnected,
      'advertisementData': advertisementData,
    };
  }
}