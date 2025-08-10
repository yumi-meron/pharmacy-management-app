import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharmacist_mobile/core/constants/api_constants.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../models/cart_item_model.dart';
import '../models/user_model.dart';

abstract class CartRemoteDataSource {
  Future<Either<Failure, List<CartItemModel>>> getCartItems();
  Future<Either<Failure, Unit>> removeCartItem(String id);
  Future<Either<Failure, Unit>> addCartItem(String medicineVariantId, int quantity);
  Future<Either<Failure, Unit>> checkoutCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  late final http.Client _client;
  final SharedPreferences _prefs;

  CartRemoteDataSourceImpl({
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
  Future<Either<Failure, Unit>> addCartItem(String medicineVariantId, int quantity) async {
    try {
      final headers = await _getHeaders();
      final body = json.encode({
        'medicine_variant_id': medicineVariantId,
        'quantity': quantity,
      });

      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}/api/cart'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(unit);
      } else {
        final decoded = json.decode(response.body);
        return Left(ServerFailure(decoded['message'] ?? 'Failed to add item to cart'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> checkoutCart() async {
    try {
      final headers = await _getHeaders();

      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}/api/sale'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(unit);
      } else {
        final decoded = json.decode(response.body);
        return Left(ServerFailure(decoded['message'] ?? 'Failed to checkout cart'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CartItemModel>>> getCartItems() async {
    try {
      final headers = await _getHeaders();

      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/api/cart'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List items = decoded['items'] ?? [];
        print('successfully fetched cart items: $items');
        return Right(items.map((e) => CartItemModel.fromJson(e)).toList());
      } else {
        return const Left(ServerFailure('Failed to fetch cart items'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeCartItem(String id) async {
    try {
      final headers = await _getHeaders();

      final response = await _client.delete(
        Uri.parse('${ApiConstants.baseUrl}/api/cart/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return const Right(unit);
      } else {
        return const Left(ServerFailure('Failed to remove item from cart'));
      }
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
