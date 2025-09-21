import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/ota_progress.dart';
import '../../domain/entities/sensor_data.dart';
import '../models/ble_device_model.dart';
import '../models/ota_progress_model.dart';
import '../models/sensor_data_model.dart';

abstract class BleDataSource {
  Stream<List<BleDeviceModel>> scanForDevices();
  Future<BleDeviceModel> connectToDevice(String deviceId);
  Future<void> disconnectFromDevice(String deviceId);
  Stream<SensorData> streamSensorData(String deviceId);
  Stream<OtaProgress> updateFirmware(String deviceId, List<int> firmwareData);
  Future<bool> isBluetoothEnabled();
  Future<void> enableBluetooth();
}

class BleDataSourceImpl implements BleDataSource {
  final Map<String, BluetoothDevice> _connectedDevices = {};

  // Service and Characteristic UUIDs (example values)
  static const String serviceUuid = "12345678-1234-1234-1234-123456789abc";
  static const String dataCharacteristicUuid =
      "87654321-4321-4321-4321-cba987654321";
  static const String otaCharacteristicUuid =
      "11111111-2222-3333-4444-555555555555";

  @override
  Future<bool> isBluetoothEnabled() async {
    final adapterState = await FlutterBluePlus.adapterState.first;
    return adapterState == BluetoothAdapterState.on;
  }

  @override
  Future<void> enableBluetooth() async {
    if (!await isBluetoothEnabled()) {
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
          devices.add(
            BleDeviceModel(
              id: result.device.remoteId.str,
              name: result.device.platformName,
              rssi: result.rssi,
              isConnected: false,
              advertisementData: {
                'localName': result.advertisementData.advName,
                'manufacturerData': result.advertisementData.manufacturerData,
                'serviceUuids': result.advertisementData.serviceUuids
                    .map((e) => e.toString())
                    .toList(),
              },
            ),
          );
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

  @override
  Stream<SensorDataModel> streamSensorData(String deviceId) async* {
    final device = _connectedDevices[deviceId];
    if (device == null) throw Exception('Device not connected');

    final services = await device.discoverServices();
    final service = services.firstWhere(
      (s) => s.uuid.toString().toLowerCase().contains(
        serviceUuid.split('-').first.toLowerCase(),
      ),
    );

    final characteristic = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toLowerCase().contains(
        dataCharacteristicUuid.split('-').first.toLowerCase(),
      ),
    );

    await characteristic.setNotifyValue(true);

    await for (final value in characteristic.lastValueStream) {
      if (value.isNotEmpty) {
        // Parse the sensor data (example parsing)
        yield SensorDataModel(
          timestamp: DateTime.now(),
          temperature: _parseFloat(value, 0),
          humidity: _parseFloat(value, 4),
          pressure: _parseFloat(value, 8),
          batteryLevel: value.length > 12 ? value[12] : 100,
        );
      }
    }
  }

  @override
  Stream<OtaProgressModel> updateFirmware(
    String deviceId,
    List<int> firmwareData,
  ) async* {
    final device = _connectedDevices[deviceId];
    if (device == null) throw Exception('Device not connected');

    yield const OtaProgressModel(
      status: OtaStatus.preparing,
      progress: 0.0,
      message: 'Preparing for firmware update...',
    );

    try {
      final services = await device.discoverServices();
      final service = services.firstWhere(
        (s) => s.uuid.toString().toLowerCase().contains(
          serviceUuid.split('-').first.toLowerCase(),
        ),
      );

      final otaCharacteristic = service.characteristics.firstWhere(
        (c) => c.uuid.toString().toLowerCase().contains(
          otaCharacteristicUuid.split('-').first.toLowerCase(),
        ),
      );

      yield const OtaProgressModel(
        status: OtaStatus.transferring,
        progress: 0.1,
        message: 'Starting firmware transfer...',
      );

      // Transfer firmware in chunks
      const chunkSize = 20; // MTU size minus overhead
      final totalChunks = (firmwareData.length / chunkSize).ceil();

      for (int i = 0; i < totalChunks; i++) {
        final start = i * chunkSize;
        final end = (start + chunkSize < firmwareData.length)
            ? start + chunkSize
            : firmwareData.length;

        final chunk = firmwareData.sublist(start, end);
        await otaCharacteristic.write(chunk, withoutResponse: false);

        final progress = (i + 1) / totalChunks * 0.8 + 0.1; // 10% to 90%
        yield OtaProgressModel(
          status: OtaStatus.transferring,
          progress: progress,
          message: 'Transferring firmware... ${(progress * 100).toInt()}%',
        );

        // Small delay to prevent overwhelming the device
        await Future.delayed(const Duration(milliseconds: 50));
      }

      yield const OtaProgressModel(
        status: OtaStatus.verifying,
        progress: 0.9,
        message: 'Verifying firmware...',
      );

      // Simulate verification delay
      await Future.delayed(const Duration(seconds: 2));

      yield const OtaProgressModel(
        status: OtaStatus.completed,
        progress: 1.0,
        message: 'Firmware update completed successfully!',
      );
    } catch (e) {
      yield OtaProgressModel(
        status: OtaStatus.failed,
        progress: 0.0,
        error: 'Firmware update failed: $e',
      );
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

  double _parseFloat(List<int> data, int offset) {
    if (data.length <= offset + 3) return 0.0;

    // Simple float parsing (little-endian)
    final bytes = data.sublist(offset, offset + 4);
    final value =
        bytes[0] | (bytes[1] << 8) | (bytes[2] << 16) | (bytes[3] << 24);
    return value / 100.0; // Assuming values are scaled by 100
  }
}
