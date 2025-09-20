import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/ble_device_model.dart';

abstract class BleDataSource {
  Stream<List<BleDeviceModel>> scanForDevices();
  Future<BleDeviceModel> connectToDevice(String deviceId);
  Future<void> disconnectFromDevice(String deviceId);
  Future<bool> isBluetoothEnabled();
  Future<void> enableBluetooth();
}

class BleDataSourceImpl implements BleDataSource {
  final Map<String, BluetoothDevice> _connectedDevices = {};
  
  // Service and Characteristic UUIDs (example values)
  static const String serviceUuid = "12345678-1234-1234-1234-123456789abc";
  static const String dataCharacteristicUuid = "87654321-4321-4321-4321-cba987654321";
  static const String otaCharacteristicUuid = "11111111-2222-3333-4444-555555555555";
  
  @override
  Future<bool> isBluetoothEnabled() async {
    return await FlutterBluePlus.isOn;
  }
  
  @override
  Future<void> enableBluetooth() async {
    if (!await FlutterBluePlus.isOn) {
      await FlutterBluePlus.turnOn();
    }
  }
  
  @override
  Stream<List<BleDeviceModel>> scanForDevices() async* {
    // Request permissions
    await _requestPermissions();
    
    // Ensure Bluetooth is enabled
    if (!await isBluetoothEnabled()) {
      await enableBluetooth();
    }
    
    final devices = <BleDeviceModel>[];
    
    // Start scanning
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    
    await for (final results in FlutterBluePlus.scanResults) {
      devices.clear();
      for (final result in results) {
        if (result.device.platformName.isNotEmpty) {
          devices.add(BleDeviceModel(
            id: result.device.remoteId.str,
            name: result.device.platformName,
            rssi: result.rssi,
            isConnected: false,
            advertisementData: {
              'localName': result.advertisementData.localName,
              'manufacturerData': result.advertisementData.manufacturerData,
              'serviceUuids': result.advertisementData.serviceUuids.map((e) => e.toString()).toList(),
            },
          ));
        }
      }
      yield List.from(devices);
    }
  }
  
  @override
  Future<BleDeviceModel> connectToDevice(String deviceId) async {
    final scanResults = await FlutterBluePlus.scanResults.first;
    final scanResult = scanResults.firstWhere(
      (result) => result.device.remoteId.str == deviceId,
    );
    
    final device = scanResult.device;
    
    try {
      await device.connect(timeout: const Duration(seconds: 15));
      _connectedDevices[deviceId] = device;
      
      // Discover services
      await device.discoverServices();
      
      return BleDeviceModel(
        id: deviceId,
        name: device.platformName,
        rssi: scanResult.rssi,
        isConnected: true,
        advertisementData: {},
      );
    } catch (e) {
      throw Exception('Failed to connect to device: $e');
    }
  }
  
  @override
  Future<void> disconnectFromDevice(String deviceId) async {
    final device = _connectedDevices[deviceId];
    if (device != null) {
      await device.disconnect();
      _connectedDevices.remove(deviceId);
    }
  }
  
  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }
}