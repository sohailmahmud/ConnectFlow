import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ble_bloc.dart';
import '../bloc/ble_state.dart';
import '../widgets/device_list_widget.dart';
import '../widgets/device_control_widget.dart';
import '../widgets/data_visualization_widget.dart';
import '../widgets/ota_update_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLE Device Manager'), elevation: 2),
      body: BlocConsumer<BleBloc, BleState>(
        listener: (context, state) {
          if (state is BleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return _buildBody(context, state);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, BleState state) {
    if (state is BleInitial ||
        state is BleScanning ||
        state is BleDevicesFound) {
      return DeviceListWidget(state: state);
    } else if (state is BleConnecting) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Connecting to device...'),
          ],
        ),
      );
    } else if (state is BleConnected) {
      return DeviceControlWidget(device: state.device);
    } else if (state is BleDataStreaming) {
      return DataVisualizationWidget(
        device: state.device,
        dataHistory: state.dataHistory,
      );
    } else if (state is BleOtaUpdating) {
      return OtaUpdateWidget(device: state.device, progress: state.progress);
    } else {
      return const Center(child: Text('Unknown state'));
    }
  }
}
