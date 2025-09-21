import 'dart:convert';
import 'package:connectflow/data/models/ota_progress_model.dart';
import 'package:connectflow/domain/entities/ota_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tOtaProgressModel = OtaProgressModel(
    status: OtaStatus.transferring,
    progress: 0.5,
    message: 'Transferring firmware...',
  );

  group('OtaProgressModel', () {
    test('should be a subclass of OtaProgress entity', () {
      // Assert
      expect(tOtaProgressModel, isA<OtaProgress>());
    });

    group('fromJson', () {
      test('should return a valid model when JSON is valid', () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'status': 'transferring',
          'progress': 0.5,
          'message': 'Transferring firmware...',
          'error': null,
        };

        // Act
        final result = OtaProgressModel.fromJson(jsonMap);

        // Assert
        expect(result, tOtaProgressModel);
      });

      test('should handle all OTA status types', () {
        // Arrange & Act & Assert
        for (final status in OtaStatus.values) {
          final jsonMap = {
            'status': status.toString().split('.').last,
            'progress': 0.5,
            'message': null,
            'error': null,
          };

          final result = OtaProgressModel.fromJson(jsonMap);
          expect(result.status, status);
        }
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tOtaProgressModel.toJson();

        // Assert
        final expectedMap = {
          'status': 'transferring',
          'progress': 0.5,
          'message': 'Transferring firmware...',
          'error': null,
        };
        expect(result, expectedMap);
      });
    });

    group('JSON serialization', () {
      test(
        'should maintain data integrity through serialize/deserialize cycle',
        () {
          // Arrange
          final jsonString = json.encode(tOtaProgressModel.toJson());

          // Act
          final jsonMap = json.decode(jsonString);
          final result = OtaProgressModel.fromJson(jsonMap);

          // Assert
          expect(result, tOtaProgressModel);
        },
      );
    });
  });
}
