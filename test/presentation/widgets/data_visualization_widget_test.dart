import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectflow/domain/entities/ble_device.dart';
import 'package:connectflow/domain/entities/sensor_data.dart';
import 'package:connectflow/presentation/bloc/ble_bloc.dart';
import 'package:connectflow/presentation/bloc/ble_event.dart';
import 'package:connectflow/presentation/bloc/ble_state.dart';
import 'package:connectflow/presentation/widgets/data_visualization_widget.dart';

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

  final tSensorData = [
    SensorData(
      timestamp: DateTime.now(),
      temperature: 25.5,
      humidity: 60.0,
      pressure: 1013.25,
      batteryLevel: 85,
    ),
    SensorData(
      timestamp: DateTime.now().add(const Duration(seconds: 1)),
      temperature: 26.0,
      humidity: 61.0,
      pressure: 1014.0,
      batteryLevel: 84,
    ),
  ];

  Widget createTestWidget(List<SensorData> dataHistory) {
    return MaterialApp(
      home: BlocProvider<BleBloc>.value(
        value: mockBleBloc,
        child: DataVisualizationWidget(
          device: tDevice,
          dataHistory: dataHistory,
        ),
      ),
    );
  }

  group('DataVisualizationWidget', () {
    testWidgets('should display device name in app bar', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(tSensorData));

      // Assert
      expect(find.text('Data from Test Device'), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsOneWidget);
    });

    testWidgets('should display sensor data cards when data is available', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(tSensorData));

      // Assert
      expect(find.text('Temperature'), findsOneWidget);
      expect(find.text('26.0°C'), findsOneWidget);
      expect(find.text('Humidity'), findsOneWidget);
      expect(find.text('61.0%'), findsOneWidget);
      expect(find.text('Pressure'), findsOneWidget);
      expect(find.text('1014.0 hPa'), findsOneWidget);
      expect(find.text('Battery'), findsOneWidget);
      expect(find.text('84%'), findsOneWidget);
    });

    testWidgets('should display data history', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(tSensorData));

      // Assert
      expect(find.text('Data History'), findsOneWidget);
      expect(find.text('25.5°C, 60.0%'), findsOneWidget);
      expect(find.text('26.0°C, 61.0%'), findsOneWidget);
    });

    testWidgets('should show no data message when history is empty', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget([]));

      // Assert
      expect(find.text('No data available'), findsOneWidget);
    });

    testWidgets('should trigger stop streaming when stop button is tapped', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(tSensorData));

      // Act
      await tester.tap(find.byIcon(Icons.stop));
      await tester.pump();

      // Assert
      verify(() => mockBleBloc.add(any())).called(1);
    });
  });
}
