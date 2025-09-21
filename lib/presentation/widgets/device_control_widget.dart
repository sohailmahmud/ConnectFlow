import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ble_device.dart';
import '../bloc/ble_bloc.dart';
import '../bloc/ble_event.dart';

class DeviceControlWidget extends StatelessWidget {
  final BleDevice device;

  const DeviceControlWidget({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bluetooth_connected, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'Connected Device',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Name: ${device.name}'),
                  Text('ID: ${device.id}'),
                  Text('RSSI: ${device.rssi} dBm'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<BleBloc>().add(StartDataStreamEvent(device.id));
            },
            icon: const Icon(Icons.sensors),
            label: const Text('Start Data Streaming'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _showFirmwareUpdateDialog(context),
            icon: const Icon(Icons.system_update),
            label: const Text('Update Firmware'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              context.read<BleBloc>().add(DisconnectFromDeviceEvent(device.id));
            },
            icon: const Icon(Icons.bluetooth_disabled),
            label: const Text('Disconnect'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _showFirmwareUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Firmware Update'),
        content: const Text(
          'This will simulate a firmware update process. '
          'In a real app, you would select a firmware file. '
          'Continue with simulation?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Simulate firmware data (in real app, load from file)
              final dummyFirmware = List.generate(1024, (i) => i % 256);
              context.read<BleBloc>().add(
                StartFirmwareUpdateEvent(device.id, dummyFirmware),
              );
            },
            child: const Text('Start Update'),
          ),
        ],
      ),
    );
  }
}
