import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/entities/ota_progress.dart';
import '../bloc/ble_bloc.dart';
import '../bloc/ble_event.dart';

class OtaUpdateWidget extends StatelessWidget {
  final BleDevice device;
  final OtaProgress progress;
  
  const OtaUpdateWidget({
    super.key,
    required this.device,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.system_update, size: 32, color: Colors.blue),
                      const SizedBox(width: 16),
                      Text(
                        'Updating ${device.name}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    _getStatusText(),
                    style: TextStyle(
                      fontSize: 16,
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (progress.message != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      progress.message!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (progress.error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      progress.error!,
                      style: const TextStyle(fontSize: 14, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    '${(progress.progress * 100).toInt()}%',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if (progress.status == OtaStatus.completed || progress.status == OtaStatus.failed)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<BleBloc>().add(DisconnectFromDeviceEvent(device.id));
                        },
                        child: const Text('Done'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressIndicator() {
    switch (progress.status) {
      case OtaStatus.preparing:
      case OtaStatus.verifying:
        return const CircularProgressIndicator();
      case OtaStatus.transferring:
        return LinearProgressIndicator(
          value: progress.progress,
          minHeight: 8,
        );
      case OtaStatus.completed:
        return const LinearProgressIndicator(
          value: 1.0,
          minHeight: 8,
          backgroundColor: Colors.green,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        );
      case OtaStatus.failed:
        return const LinearProgressIndicator(
          value: 1.0,
          minHeight: 8,
          backgroundColor: Colors.red,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        );
      default:
        return const LinearProgressIndicator(value: 0);
    }
  }
  
  String _getStatusText() {
    switch (progress.status) {
      case OtaStatus.idle:
        return 'Ready';
      case OtaStatus.preparing:
        return 'Preparing...';
      case OtaStatus.transferring:
        return 'Transferring firmware...';
      case OtaStatus.verifying:
        return 'Verifying...';
      case OtaStatus.completed:
        return 'Update completed successfully!';
      case OtaStatus.failed:
        return 'Update failed';
    }
  }
  
  Color _getStatusColor() {
    switch (progress.status) {
      case OtaStatus.completed:
        return Colors.green;
      case OtaStatus.failed:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}