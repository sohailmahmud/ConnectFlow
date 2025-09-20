import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ble_device.dart';
import '../bloc/ble_bloc.dart';
import '../bloc/ble_event.dart';
import '../bloc/ble_state.dart';

class DeviceListWidget extends StatelessWidget {
  final BleState state;
  
  const DeviceListWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Devices',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (state is BleScanning) {
                    context.read<BleBloc>().add(StopScanningEvent());
                  } else {
                    context.read<BleBloc>().add(StartScanningEvent());
                  }
                },
                icon: Icon(state is BleScanning ? Icons.stop : Icons.search),
                label: Text(state is BleScanning ? 'Stop' : 'Scan'),
              ),
            ],
          ),
        ),
        if (state is BleScanning)
          const LinearProgressIndicator(),
        Expanded(
          child: _buildDeviceList(),
        ),
      ],
    );
  }
  
  Widget _buildDeviceList() {
    if (state is BleDevicesFound) {
      final devices = (state as BleDevicesFound).devices;
      
      if (devices.isEmpty) {
        return const Center(
          child: Text('No devices found. Try scanning again.'),
        );
      }
      
      return ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return DeviceListTile(device: devices[index]);
        },
      );
    }
    
    return const Center(
      child: Text('Tap scan to find BLE devices'),
    );
  }
}

class DeviceListTile extends StatelessWidget {
  final BleDevice device;
  
  const DeviceListTile({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRssiColor(device.rssi),
          child: Text(
            device.rssi.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        title: Text(
          device.name.isNotEmpty ? device.name : 'Unknown Device',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${device.id}'),
            Text('RSSI: ${device.rssi} dBm'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            context.read<BleBloc>().add(ConnectToDeviceEvent(device.id));
          },
          child: const Text('Connect'),
        ),
      ),
    );
  }
  
  Color _getRssiColor(int rssi) {
    if (rssi >= -40) return Colors.green;
    if (rssi >= -60) return Colors.orange;
    return Colors.red;
  }
}