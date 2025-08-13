import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/failure.dart';
import '../models/order_model.dart';
import '../models/order_detail_model.dart';
import '../models/order_item_model.dart';
import '../models/patient_model.dart';
import '../../data/models/user_model.dart';

abstract class OrdersRemoteDataSource {
  Future<Either<Failure, List<OrderModel>>> getOrders();
  Future<Either<Failure, OrderDetailModel>> getOrderDetail(String id);
  Future<Either<Failure, Unit>> requestOrderOtp(String id, String phoneNumber);
  Future<Either<Failure, Unit>> verifyOrderOtp(String id, String otp);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  late final http.Client _client;
  final SharedPreferences _prefs;

  OrdersRemoteDataSourceImpl({
    http.Client? client,
    required SharedPreferences prefs,
  }) : _prefs = prefs {
    _client = client ?? http.Client();
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

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders() async {
    try {
      final headers = await _getHeaders();

      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/api/orders'),
        headers: headers,
      );
      

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final items = data.map((e) => OrderModel.fromJson(e)).toList();
        return Right(items);
      } else {
        final decoded = json.decode(response.body);
        return Left(ServerFailure(decoded['message'] ?? 'Failed to fetch orders'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, OrderDetailModel>> getOrderDetail(String id) async {
    try {
      final headers = await _getHeaders();

      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/api/orders/$id'),
        headers: headers,
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        final model = OrderDetailModel.fromJson(decoded);
        return Right(model);
      } else {
        final decoded = json.decode(response.body);
        return Left(ServerFailure(decoded['message'] ?? 'Failed to fetch order detail'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestOrderOtp(String id, String phoneNumber) async {
    try {
      final headers = await _getHeaders();
      final body = json.encode({'phone_number': phoneNumber});

      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}/api/orders/$id/request-otp'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(unit);
      } else {
        final decoded = json.decode(response.body);
        return Left(ServerFailure(decoded['message'] ?? 'Failed to request OTP'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyOrderOtp(String id, String otp) async {
    try {
      final headers = await _getHeaders();
      final body = json.encode({'otp': otp});

      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}/api/orders/$id/verify'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(unit);
      } else {
        final decoded = json.decode(response.body);
        return Left(ServerFailure(decoded['message'] ?? 'Failed to verify OTP'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
