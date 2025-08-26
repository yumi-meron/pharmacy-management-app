import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:pharmacist_mobile/core/constants/api_constants.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/data/models/user_model.dart';
import 'package:pharmacist_mobile/data/models/medicine_model.dart';
import 'package:pharmacist_mobile/data/models/update_medicine_model.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';

/// 🔹 Abstract definition
abstract class MedicineRemoteDataSource {
  Future<Either<Failure, List<Medicine>>> getAllMedicines();
  Future<Either<Failure, List<Medicine>>> searchMedicines(String query);
  Future<Either<Failure, Medicine>> getMedicineDetails(String id);
  Future<UpdateMedicineModel> updateMedicine(UpdateMedicineModel medicine);
  Future<MedicineModel> getMedicineByBarcode(String barcode);

}

/// 🔹 Implementation
class MedicineRemoteDataSourceImpl implements MedicineRemoteDataSource {
  late final http.Client _httpClient;
  final FlutterSecureStorage _storage;

  MedicineRemoteDataSourceImpl({
    http.Client? client,
    required FlutterSecureStorage storage,
  }) : _storage = storage {
    _httpClient = client ?? http.Client();
  }

  /// 🔹 Private helper for headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: "token");
    final userJson = await _storage.read(key: 'user')?? '';

    if (token == null) throw Exception('No token found');
    if (userJson == '') throw Exception('No user data found');

    final userMap = jsonDecode(userJson);
    final user = UserModel.fromJson(userMap);

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'role': user.role,
      'pharmacy_id': user.pharmacyId.toString(),
    };
  }

  /// 🔹 Get all medicines
  @override
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

  @override
  Future<MedicineModel> getMedicineByBarcode(String barcode) async {
    final uri = Uri.parse("${ApiConstants.baseUrl}/api/medicines/barcode/$barcode");
    final headers = await _getHeaders();

    final response = await _httpClient.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MedicineModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch medicine: ${response.body}");
    }
  }

  /// 🔹 Update medicine
  @override
  Future<UpdateMedicineModel> updateMedicine(UpdateMedicineModel medicine) async {
    final headers = await _getHeaders();
    final uri = Uri.parse(
    '${ApiConstants.baseUrl}/api/medicines/${medicine.id}/variants/${medicine.variantid}',
  );

  // Use MultipartRequest for file + fields
  final request = http.MultipartRequest("PUT", uri);

  // Add headers (excluding Content-Type, since Multipart will set it automatically)
  request.headers.addAll(headers..remove('Content-Type'));

  // Add text fields
  request.fields['name'] = medicine.name;
  request.fields['description'] = medicine.description;
  request.fields['barcode'] = medicine.barcode;
  request.fields['unit'] = medicine.unit;
  request.fields['brand'] = medicine.brand;
  request.fields['price'] = medicine.price.toString();
  request.fields['quantityAvailable'] = medicine.quantityAvailable.toString();
  request.fields['expiryDate'] = medicine.expiryDate;

  // Handle image upload if provided
  if (medicine.imageUrl.isNotEmpty && File(medicine.imageUrl).existsSync()) {
    final file = File(medicine.imageUrl);
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // 🔹 field name expected by API
        file.path,
        contentType: MediaType('image', 'jpeg'), // or png if needed
      ),
    );
  }

  // Send request
  final streamedResponse = await _httpClient.send(request);
  final response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return UpdateMedicineModel.fromJson(data);
  } else {
    throw Exception("Failed to update medicine: ${response.body}");
  }
}

  /// 🔹 Search medicines
  @override
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

  /// 🔹 Get medicine details
  @override
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
