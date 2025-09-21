import 'package:connectflow/data/datasources/ble_datasource.dart';
import 'package:connectflow/domain/repositories/ble_repository.dart';
import 'package:connectflow/domain/usecases/connect_device.dart';
import 'package:connectflow/domain/usecases/scan_devices.dart';
import 'package:connectflow/domain/usecases/stream_data.dart';
import 'package:connectflow/domain/usecases/update_firmware.dart';
import 'package:connectflow/presentation/bloc/ble_bloc.dart';
import 'package:mocktail/mocktail.dart';

// Data Sources
class MockBleDataSource extends Mock implements BleDataSource {}

// Repositories
class MockBleRepository extends Mock implements BleRepository {}

// Use Cases
class MockScanDevicesUseCase extends Mock implements ScanDevicesUseCase {}
class MockConnectDeviceUseCase extends Mock implements ConnectDeviceUseCase {}
class MockStreamDataUseCase extends Mock implements StreamDataUseCase {}
class MockUpdateFirmwareUseCase extends Mock implements UpdateFirmwareUseCase {}

// BLoC
class MockBleBloc extends Mock implements BleBloc {}

// Register fallback values for mocktail
void registerFallbackValues() {
  registerFallbackValue(UpdateFirmwareParams(
    deviceId: 'fallback-device-id',
    firmwareData: [],
  ));
}