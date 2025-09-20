import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/entities/sensor_data.dart';
import '../bloc/ble_bloc.dart';
import '../bloc/ble_event.dart';

class DataVisualizationWidget extends StatelessWidget {
  final BleDevice device;
  final List<SensorData> dataHistory;
  
  const DataVisualizationWidget({
    super.key,
    required this.device,
    required this.dataHistory,
  });

  @override
  Widget build(BuildContext context) {
    final latestData = dataHistory.isNotEmpty ? dataHistory.last : null;
    
    return Column(
      children: [
        AppBar(
          title: Text('Data from ${device.name}'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                context.read<BleBloc>().add(StopDataStreamEvent());
              },
              icon: const Icon(Icons.stop),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (latestData != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildDataCard(
                          'Temperature',
                          '${latestData.temperature.toStringAsFixed(1)}°C',
                          Icons.thermostat,
                          Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDataCard(
                          'Humidity',
                          '${latestData.humidity.toStringAsFixed(1)}%',
                          Icons.water_drop,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDataCard(
                          'Pressure',
                          '${latestData.pressure.toStringAsFixed(1)} hPa',
                          Icons.compress,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDataCard(
                          'Battery',
                          '${latestData.batteryLevel}%',
                          Icons.battery_std,
                          _getBatteryColor(latestData.batteryLevel),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Data History',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: _buildDataChart(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildDataCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDataChart() {
    if (dataHistory.isEmpty) {
      return const Center(child: Text('No data available'));
    }
    
    return ListView.builder(
      itemCount: dataHistory.length,
      itemBuilder: (context, index) {
        final data = dataHistory[index];
        return ListTile(
          dense: true,
          leading: CircleAvatar(
            radius: 16,
            child: Text('${index + 1}'),
          ),
          title: Text(
            '${data.temperature.toStringAsFixed(1)}°C, ${data.humidity.toStringAsFixed(1)}%',
          ),
          subtitle: Text(
            '${data.pressure.toStringAsFixed(1)} hPa, Battery: ${data.batteryLevel}%',
          ),
          trailing: Text(
            '${data.timestamp.hour}:${data.timestamp.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }
  
  Color _getBatteryColor(int batteryLevel) {
    if (batteryLevel > 50) return Colors.green;
    if (batteryLevel > 20) return Colors.orange;
    return Colors.red;
  }
}