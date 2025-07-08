import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pharmacist_mobile/core/constants/api_constants.dart';
import 'package:pharmacist_mobile/data/datasources/medicine_remote_data_source.dart';
import 'medicine_remote_datasource_api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MedicineRemoteDataSource dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = MedicineRemoteDataSource(client: mockClient);
  });

  tearDown(() {
    mockClient.close();
  });

  group('MedicineRemoteDataSource API Calls', () {
    test('searchMedicines returns list of medicines when successful', () async {
      when(mockClient.get(Uri.parse('$ApiConstants.baseUrl/medicines/search?query=test')))
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

      expect(result.length, 1);
      expect(result.first.name, 'Amoxicillin');
    });

    test('searchMedicines throws exception on non-200 response', () async {
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('Error', 500));

      expect(() => dataSource.searchMedicines('test'), throwsException);
    });

    test('getMedicineDetails returns medicine when successful', () async {
      when(mockClient.get(Uri.parse('$ApiConstants.baseUrl/medicines/550e8400-e29b-41d4-a716-446655440000')))
          .thenAnswer((_) async => http.Response('''
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

      expect(result.name, 'Amoxicillin');
    });

    test('getMedicineDetails throws exception on non-200 response', () async {
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('Error', 404));

      expect(() => dataSource.getMedicineDetails('invalid-id'), throwsException);
    });
  });
}