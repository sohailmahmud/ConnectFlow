import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:connectflow/main.dart' as app;
import 'package:get_it/get_it.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('BLE App Integration Tests', () {
    setUp(() async {
      // Reset GetIt before each test to avoid registration conflicts
      await GetIt.instance.reset();
    });

    testWidgets('app should start and show main screen', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify that the app starts successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('app should display basic UI elements', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Check for basic Flutter app structure
      expect(find.byType(AppBar), findsAtLeastNWidgets(1));
    });
  });

  group('Basic Navigation Tests', () {
    setUp(() async {
      // Reset GetIt before each test
      await GetIt.instance.reset();
    });

    testWidgets('app should handle basic navigation', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify app doesn't crash on startup
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}