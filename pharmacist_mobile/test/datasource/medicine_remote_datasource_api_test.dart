import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dartz/dartz.dart';

import 'package:pharmacist_mobile/core/constants/api_constants.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/data/datasources/medicine_remote_data_source.dart';
import 'medicine_remote_datasource_api_test.mocks.dart';

@GenerateMocks([http.Client, SharedPreferences])
void main() {
  late MedicineRemoteDataSource dataSource;
  late MockClient mockClient;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockClient = MockClient();
    mockPrefs = MockSharedPreferences();

    when(mockPrefs.getString('token')).thenReturn('mock_token');

    dataSource = MedicineRemoteDataSource(client: mockClient, prefs: mockPrefs);
  });

  tearDown(() {
    mockClient.close();
  });

  group('MedicineRemoteDataSource API Calls', () {
    test('searchMedicines returns Right(List<Medicine>) on success', () async {
      when(mockClient.get(Uri.parse('${ApiConstants.baseUrl}/medicines/search?query=test'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('''
          [
            {
              "id": "550e8400-e29b-41d4-a716-446655440000",
              "name": "Amoxicillin",
              "category": "Antibiotics",
              "description": "An antibiotic",
              "created_at": "2025-07-01T10:00:00Z",
              "picture": "https://via.placeholder.com/100",
              "variants": [
                {
                  "id": "1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d",
                  "medicine_id": "550e8400-e29b-41d4-a716-446655440000",
                  "brand": "Pfizer",
                  "barcode": "123456789012",
                  "unit": "piece",
                  "price_per_unit": 50.0,
                  "expiry_date": "2026-06-30",
                  "quantity_available": 100,
                  "created_at": "2025-07-01T10:00:00Z",
                  "updated_at": "2025-07-03T12:00:00Z"
                }
              ]
            }
          ]
          ''', 200));

      final result = await dataSource.searchMedicines('test');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not be Left'),
        (medicines) {
          expect(medicines.length, 1);
          expect(medicines.first.name, 'Amoxicillin');
        },
      );
    });

    test('searchMedicines returns Left(ServerFailure) on non-200', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Error', 500));

      final result = await dataSource.searchMedicines('test');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should not return Right'),
      );
    });

    test('getMedicineDetails returns Right(Medicine) on success', () async {
      when(mockClient.get(
        Uri.parse('${ApiConstants.baseUrl}/medicines/550e8400-e29b-41d4-a716-446655440000'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('''
        {
          "id": "550e8400-e29b-41d4-a716-446655440000",
          "name": "Amoxicillin",
          "category": "Antibiotics",
          "description": "An antibiotic",
          "created_at": "2025-07-01T10:00:00Z",
          "picture": "https://via.placeholder.com/100",
          "variants": [
            {
              "id": "1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d",
              "medicine_id": "550e8400-e29b-41d4-a716-446655440000",
              "brand": "Pfizer",
              "barcode": "123456789012",
              "unit": "piece",
              "price_per_unit": 50.0,
              "expiry_date": "2026-06-30",
              "quantity_available": 100,
              "created_at": "2025-07-01T10:00:00Z",
              "updated_at": "2025-07-03T12:00:00Z"
            }
          ]
        }
      ''', 200));

      final result = await dataSource.getMedicineDetails('550e8400-e29b-41d4-a716-446655440000');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not be Left'),
        (medicine) => expect(medicine.name, 'Amoxicillin'),
      );
    });

    test('getMedicineDetails returns Left(ServerFailure) on non-200', () async {
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Error', 404));

      final result = await dataSource.getMedicineDetails('invalid-id');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should not return Right'),
      );
    });
  });
}
