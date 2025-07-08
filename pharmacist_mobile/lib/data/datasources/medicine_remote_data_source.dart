import 'package:http/http.dart' as http;
import 'package:pharmacist_mobile/core/constants/api_constants.dart';
import 'package:pharmacist_mobile/data/models/medicine_model.dart';
import 'dart:convert';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';

class MedicineRemoteDataSource {
  late final http.Client _httpClient;

  MedicineRemoteDataSource({http.Client? client}) {
    _httpClient = client ?? http.Client();
  }

  Future<List<Medicine>> searchMedicines(String query) async {
    final response = await _httpClient.get(
        Uri.parse('${ApiConstants.baseUrl}/medicines/search?query=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => MedicineModel.fromJson(json).toEntity())
          .toList();
    } else {
      throw Exception('Failed to load medicines');
    }
  }

  Future<Medicine> getMedicineDetails(String id) async {
    final response = await _httpClient
        .get(Uri.parse('${ApiConstants.baseUrl}/medicines/$id'));
    if (response.statusCode == 200) {
      return MedicineModel.fromJson(json.decode(response.body)).toEntity();
    } else {
      throw Exception('Failed to load medicine details');
    }
  }
}
