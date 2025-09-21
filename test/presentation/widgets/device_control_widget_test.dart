import 'package:connectflow/domain/entities/ble_device.dart';
import 'package:connectflow/presentation/bloc/ble_bloc.dart';
import 'package:connectflow/presentation/bloc/ble_event.dart';
import 'package:connectflow/presentation/bloc/ble_state.dart';
import 'package:connectflow/presentation/widgets/device_control_widget.dart';
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

  const tDevice = BleDevice(
    id: 'test-device-id',
    name: 'Test Device',
    rssi: -50,
    isConnected: true,
    advertisementData: {},
  );

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<BleBloc>.value(
        value: mockBleBloc,
        child: const Scaffold(body: DeviceControlWidget(device: tDevice)),
      ),
    );
  }

  group('DeviceControlWidget', () {
    testWidgets('should display device information', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Connected Device'), findsOneWidget);
      expect(find.text('Name: Test Device'), findsOneWidget);
      expect(find.text('ID: test-device-id'), findsOneWidget);
      expect(find.text('RSSI: -50 dBm'), findsOneWidget);
      expect(find.byIcon(Icons.bluetooth_connected), findsOneWidget);
    });

    testWidgets('should show all control buttons', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Start Data Streaming'), findsOneWidget);
      expect(find.text('Update Firmware'), findsOneWidget);
      expect(find.text('Disconnect'), findsOneWidget);
      expect(find.byIcon(Icons.sensors), findsOneWidget);
      expect(find.byIcon(Icons.system_update), findsOneWidget);
      expect(find.byIcon(Icons.bluetooth_disabled), findsOneWidget);
    });

    testWidgets('should trigger data streaming when button is tapped', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.tap(find.text('Start Data Streaming'));
      await tester.pump();

      // Assert
      verify(() => mockBleBloc.add(any())).called(1);
    });

    testWidgets('should show firmware update dialog when button is tapped', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.tap(find.text('Update Firmware'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Firmware Update'), findsOneWidget);
      expect(
        find.textContaining('This will simulate a firmware update process'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Start Update'), findsOneWidget);
    });

    testWidgets('should trigger disconnect when disconnect button is tapped', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.tap(find.text('Disconnect'));
      await tester.pump();

      // Assert
      verify(() => mockBleBloc.add(any())).called(1);
    });

    testWidgets('should start firmware update when confirmed in dialog', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.tap(find.text('Update Firmware'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start Update'));
      await tester.pump();

      // Assert
      verify(() => mockBleBloc.add(any())).called(1);
    });
  });
}
