import 'package:bloc_test/bloc_test.dart';
import 'package:connectflow/core/errors/failures.dart';
import 'package:connectflow/core/usecases/usecase.dart';
import 'package:connectflow/domain/entities/ble_device.dart';
import 'package:connectflow/domain/entities/sensor_data.dart';
import 'package:connectflow/domain/usecases/connect_device.dart';
import 'package:connectflow/domain/usecases/scan_devices.dart';
import 'package:connectflow/domain/usecases/stream_data.dart';
import 'package:connectflow/domain/usecases/update_firmware.dart';
import 'package:connectflow/presentation/bloc/ble_bloc.dart';
import 'package:connectflow/presentation/bloc/ble_event.dart';
import 'package:connectflow/presentation/bloc/ble_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockScanDevicesUseCase extends Mock implements ScanDevicesUseCase {}

class MockConnectDeviceUseCase extends Mock implements ConnectDeviceUseCase {}

class MockStreamDataUseCase extends Mock implements StreamDataUseCase {}

class MockUpdateFirmwareUseCase extends Mock implements UpdateFirmwareUseCase {}

void main() {
  late BleBloc bloc;
  late MockScanDevicesUseCase mockScanDevicesUseCase;
  late MockConnectDeviceUseCase mockConnectDeviceUseCase;
  late MockStreamDataUseCase mockStreamDataUseCase;
  late MockUpdateFirmwareUseCase mockUpdateFirmwareUseCase;

  setUp(() {
    mockScanDevicesUseCase = MockScanDevicesUseCase();
    mockConnectDeviceUseCase = MockConnectDeviceUseCase();
    mockStreamDataUseCase = MockStreamDataUseCase();
    mockUpdateFirmwareUseCase = MockUpdateFirmwareUseCase();

    bloc = BleBloc(
      scanDevicesUseCase: mockScanDevicesUseCase,
      connectDeviceUseCase: mockConnectDeviceUseCase,
      streamDataUseCase: mockStreamDataUseCase,
      updateFirmwareUseCase: mockUpdateFirmwareUseCase,
    );
  });

  group('BleBloc', () {
    const tDevices = [
      BleDevice(
        id: 'device-1',
        name: 'Test Device 1',
        rssi: -50,
        isConnected: false,
        advertisementData: {},
      ),
    ];

    const tDevice = BleDevice(
      id: 'device-1',
      name: 'Test Device 1',
      rssi: -50,
      isConnected: true,
      advertisementData: {},
    );

    group('StartScanningEvent', () {
      blocTest<BleBloc, BleState>(
        'should emit [BleScanning, BleDevicesFound] when scanning succeeds',
        build: () {
          when(
            () => mockScanDevicesUseCase(const NoParams()),
          ).thenAnswer((_) => Stream.value(const Right(tDevices)));
          return bloc;
        },
        act: (bloc) => bloc.add(StartScanningEvent()),
        expect: () => [BleScanning(), const BleDevicesFound(tDevices)],
        verify: (_) {
          verify(() => mockScanDevicesUseCase(const NoParams())).called(1);
        },
      );

      blocTest<BleBloc, BleState>(
        'should emit [BleScanning, BleError] when scanning fails',
        build: () {
          when(() => mockScanDevicesUseCase(const NoParams())).thenAnswer(
            (_) => Stream.value(const Left(BleFailure('Scan failed'))),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(StartScanningEvent()),
        expect: () => [BleScanning(), isA<BleError>()],
      );
    });

    group('ConnectToDeviceEvent', () {
      const tDeviceId = 'device-1';

      blocTest<BleBloc, BleState>(
        'should emit [BleConnecting, BleConnected] when connection succeeds',
        build: () {
          when(
            () => mockConnectDeviceUseCase(tDeviceId),
          ).thenAnswer((_) async => const Right(tDevice));
          return bloc;
        },
        act: (bloc) => bloc.add(const ConnectToDeviceEvent(tDeviceId)),
        expect: () => [
          const BleConnecting(tDeviceId),
          const BleConnected(tDevice),
        ],
        verify: (_) {
          verify(() => mockConnectDeviceUseCase(tDeviceId)).called(1);
        },
      );

      blocTest<BleBloc, BleState>(
        'should emit [BleConnecting, BleError] when connection fails',
        build: () {
          when(
            () => mockConnectDeviceUseCase(tDeviceId),
          ).thenAnswer((_) async => Left(ConnectionFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const ConnectToDeviceEvent(tDeviceId)),
        expect: () => [const BleConnecting(tDeviceId), isA<BleError>()],
      );
    });

    group('StartDataStreamEvent', () {
      const tDeviceId = 'device-1';
      final tSensorData = SensorData(
        timestamp: DateTime.now(),
        temperature: 25.5,
        humidity: 60.0,
        pressure: 1013.25,
        batteryLevel: 85,
      );

      blocTest<BleBloc, BleState>(
        'should emit [BleDataStreaming] when data streaming starts successfully',
        build: () {
          // Mock successful connection first
          when(
            () => mockConnectDeviceUseCase(tDeviceId),
          ).thenAnswer((_) async => Right(tDevice));
          // Mock successful data streaming
          when(
            () => mockStreamDataUseCase(tDeviceId),
          ).thenAnswer((_) => Stream.value(Right(tSensorData)));
          return bloc;
        },
        act: (bloc) async {
          // First connect to device to set up internal state
          bloc.add(ConnectToDeviceEvent(tDeviceId));
          await Future.delayed(Duration.zero); // Allow connection to complete
          // Then start data streaming
          bloc.add(StartDataStreamEvent(tDeviceId));
        },
        expect: () => [
          BleConnecting(tDeviceId),
          BleConnected(tDevice),
          BleDataStreaming(tDevice, [tSensorData]),
        ],
        verify: (_) {
          verify(() => mockConnectDeviceUseCase(tDeviceId)).called(1);
          verify(() => mockStreamDataUseCase(tDeviceId)).called(1);
        },
      );

      blocTest<BleBloc, BleState>(
        'should emit [BleError] when no device is connected',
        build: () => bloc,
        act: (bloc) => bloc.add(const StartDataStreamEvent(tDeviceId)),
        expect: () => [const BleError('No device connected')],
        verify: (_) {
          verifyNever(() => mockStreamDataUseCase(any()));
        },
      );
    });
  });
}
