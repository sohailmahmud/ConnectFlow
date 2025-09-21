import 'package:connectflow/domain/entities/ble_device.dart';
import 'package:connectflow/presentation/bloc/ble_bloc.dart';
import 'package:connectflow/presentation/bloc/ble_event.dart';
import 'package:connectflow/presentation/bloc/ble_state.dart';
import 'package:connectflow/presentation/widgets/device_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockBleBloc extends Mock implements BleBloc {}

class FakeBleEvent extends Fake implements BleEvent {}

void main() {
  late MockBleBloc mockBleBloc;

  setUpAll(() {
    registerFallbackValue(FakeBleEvent());
  });

  setUp(() {
    mockBleBloc = MockBleBloc();

    // Setup default stream for the mock
    when(
      () => mockBleBloc.stream,
    ).thenAnswer((_) => Stream<BleState>.value(BleInitial()));
    when(() => mockBleBloc.state).thenReturn(BleInitial());
  });

  Widget createTestWidget(BleState state) {
    return MaterialApp(
      home: BlocProvider<BleBloc>.value(
        value: mockBleBloc,
        child: Scaffold(body: DeviceListWidget(state: state)),
      ),
    );
  }

  group('DeviceListWidget', () {
    testWidgets('should show scan button when in initial state', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(BleInitial()));

      // Assert
      expect(find.text('Available Devices'), findsOneWidget);
      expect(find.text('Scan'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Tap scan to find BLE devices'), findsOneWidget);
    });

    testWidgets('should show stop button when scanning', (tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(BleScanning()));

      // Assert
      expect(find.text('Stop'), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should display devices when found', (tester) async {
      // Arrange
      const devices = [
        BleDevice(
          id: 'device-1',
          name: 'Test Device',
          rssi: -50,
          isConnected: false,
          advertisementData: {},
        ),
      ];

      await tester.pumpWidget(createTestWidget(const BleDevicesFound(devices)));

      // Assert
      expect(find.text('Test Device'), findsOneWidget);
      expect(find.text('ID: device-1'), findsOneWidget);
      expect(find.text('RSSI: -50 dBm'), findsOneWidget);
      expect(find.text('Connect'), findsOneWidget);
    });

    testWidgets('should show no devices message when list is empty', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(const BleDevicesFound([])));

      // Assert
      expect(
        find.text('No devices found. Try scanning again.'),
        findsOneWidget,
      );
    });

    testWidgets('should call connect when connect button is tapped', (
      tester,
    ) async {
      // Arrange
      const devices = [
        BleDevice(
          id: 'device-1',
          name: 'Test Device',
          rssi: -50,
          isConnected: false,
          advertisementData: {},
        ),
      ];

      await tester.pumpWidget(createTestWidget(const BleDevicesFound(devices)));

      // Act
      await tester.tap(find.text('Connect'));
      await tester.pump();

      // Assert
      verify(() => mockBleBloc.add(any())).called(1);
    });
  });
}
