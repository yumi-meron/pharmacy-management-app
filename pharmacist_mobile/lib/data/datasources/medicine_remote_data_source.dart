import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacist_mobile/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pharmacist_mobile/core/constants/api_constants.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/data/models/medicine_model.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';

class MedicineRemoteDataSource {
  late final http.Client _httpClient;
  final SharedPreferences _prefs;

  MedicineRemoteDataSource({
    http.Client? client,
    required SharedPreferences prefs,
  }) : _prefs = prefs {
    _httpClient = client ?? http.Client();
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = _prefs.getString('token');
    final userJson = _prefs.getString('user');

    if (token == null) throw Exception('No token found');

    if (userJson == null) throw Exception('No user data found');
    final userMap = jsonDecode(userJson);
    final user = UserModel.fromJson(userMap);
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'role': user.role,
      'pharmacy_id': user.pharmacyId.toString(),
    };
  }

  Future<Either<Failure, List<Medicine>>> getAllMedicines() async {
    try {
      final headers = await _getHeaders();
      final response = await _httpClient.get(
        Uri.parse('${ApiConstants.baseUrl}/api/medicines'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final result = data
            .map((json) => MedicineModel.fromJson(json).toEntity())
            .toList();
        return Right(result);
      } else {
        return const Left(ServerFailure('Failed to load all medicines'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Medicine>>> searchMedicines(String query) async {
    try {
      final headers = await _getHeaders();
      final response = await _httpClient.get(
        Uri.parse('${ApiConstants.baseUrl}/api/medicines/search?query=$query'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final result = data
            .map((json) => MedicineModel.fromJson(json).toEntity())
            .toList();
        return Right(result);
      } else {
        return const Left(ServerFailure('Failed to search medicines'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, Medicine>> getMedicineDetails(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await _httpClient.get(
        Uri.parse('${ApiConstants.baseUrl}/api/medicines/$id'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = MedicineModel.fromJson(data).toEntity();
        return Right(result);
      } else {
        return const Left(ServerFailure('Failed to load medicine details'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
