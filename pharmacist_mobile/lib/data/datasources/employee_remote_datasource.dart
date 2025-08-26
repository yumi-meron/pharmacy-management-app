import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacist_mobile/core/constants/api_constants.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/data/models/user_model.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';

abstract class EmployeeDataSource {
  Future<Either<Failure, List<User>>> fetchEmployees();
  Future<Either<Failure, Unit>> createEmployee({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String role,
  });
}

class EmployeeDataSourceImpl implements EmployeeDataSource {
  late final http.Client _httpClient;
  final FlutterSecureStorage _storage;

  EmployeeDataSourceImpl({
    http.Client? client,
    required FlutterSecureStorage storage,
  }) : _storage = storage {
    _httpClient = client ?? http.Client();
  }

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

  @override
  Future<Either<Failure, Unit>> createEmployee({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String role,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = jsonEncode({
        'full_name': fullName,
        'phone_number': phoneNumber,
        'password': password,
        'role': role,
      });

      final response = await _httpClient.post(
        Uri.parse('${ApiConstants.baseUrl}/api/users/pharmacists'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return const Right(unit);
      } else {
        final decoded = json.decode(response.body);
        final message = decoded['message'] ?? 'Failed to create employee';
        return Left(ServerFailure(message));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<User>>> fetchEmployees() async {
    try {
      final headers = await _getHeaders();
      final response = await _httpClient.get(
        Uri.parse('${ApiConstants.baseUrl}/api/users/pharmacists'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final result =
            data.map((json) => UserModel.fromJson(json).toEntity()).toList();
        
        return Right(result);
      } else {
        return const Left(ServerFailure('Failed to load employees'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
