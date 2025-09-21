import 'package:flutter_test/flutter_test.dart';

import 'domain/entities/ble_device_test.dart' as ble_device_test;
import 'domain/entities/sensor_data_test.dart' as sensor_data_test;
import 'domain/usecases/scan_devices_test.dart' as scan_devices_test;
import 'domain/usecases/connect_device_test.dart' as connect_device_test;
import 'data/repositories/ble_repository_impl_test.dart' as repository_test;
import 'data/models/ble_device_model_test.dart' as model_test;
import 'presentation/bloc/ble_bloc_test.dart' as bloc_test;
import 'presentation/widgets/device_list_widget_test.dart' as widget_test;

void main() {
  group('Domain Layer Tests', () {
    ble_device_test.main();
    sensor_data_test.main();
    scan_devices_test.main();
    connect_device_test.main();
  });

  group('Data Layer Tests', () {
    repository_test.main();
    model_test.main();
  });

  group('Presentation Layer Tests', () {
    bloc_test.main();
    widget_test.main();
  });
}