import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:pharmacist_mobile/core/constants/api_constants.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/data/models/cart_data_model.dart';
import 'package:pharmacist_mobile/data/models/user_model.dart';

abstract class CartRemoteDataSource {
  Future<Either<Failure, CartDataModel>> getCartItems();
  Future<Either<Failure, Unit>> removeCartItem(String id);
  Future<Either<Failure, Unit>> addCartItem(
      String medicineVariantId, int quantity);
  Future<Either<Failure, Unit>> checkoutCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;

  CartRemoteDataSourceImpl({required this.dio, required this.storage});

  Future<Map<String, dynamic>> _getHeaders() async {
    final token = await storage.read(key: "token");
    //wait secureStorage.write(
           // key: 'user', value: jsonEncode(user.toJson()));
    final userJson = await storage.read(key: 'user')?? '';

    if (token == null) throw Exception('No token found');
    if (userJson == '') throw Exception('No user data found');

    final user = UserModel.fromJson(jsonDecode(userJson));

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'role': user.role,
      'pharmacy_id': user.pharmacyId.toString(),
      'user_id': user.id.toString(),
    };
  }

  @override
  Future<Either<Failure, Unit>> addCartItem(
      String medicineVariantId, int quantity) async {
    try {
      final headers = await _getHeaders();
      final response = await dio.post(
        '${ApiConstants.baseUrl}/api/carts',
        data: {
          'medicine_variant_id': medicineVariantId,
          'quantity': quantity,
        },
        options: Options(headers: headers, followRedirects: true),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(unit);
      } else {
        return Left(ServerFailure(
            response.data['message'] ?? 'Failed to add item to cart'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> checkoutCart() async {
    try {
      final headers = await _getHeaders();
      final response = await dio.post(
        '${ApiConstants.baseUrl}/api/sales',
        options: Options(headers: headers, followRedirects: true),
      );
      print('Checkout response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(unit);
      } else {
        return Left(ServerFailure(
            response.data['message'] ?? 'Failed to checkout cart'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CartDataModel>> getCartItems() async {
    try {
      final headers = await _getHeaders();
      final response = await dio.get(
        '${ApiConstants.baseUrl}/api/carts',
        options: Options(headers: headers, followRedirects: true),
      );
      if (response.statusCode == 200) {
        final cartData = CartDataModel.fromJson(response.data);
        return Right(cartData);
      } else {
        return const Left(ServerFailure('Failed to fetch cart items'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeCartItem(String id) async {
    try {
      final headers = await _getHeaders();
      print('before delete request');
      final response = await dio.delete(
        '${ApiConstants.baseUrl}/api/cart/$id',
        options: Options(headers: headers, followRedirects: true),
      );
      print('Remove item response: ${response.statusCode}');


      if (response.statusCode == 200) {
        return const Right(unit);
      } else {
        return const Left(ServerFailure('Failed to remove item from cart'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  String _getErrorMessage(DioException e) {
    if (e.response != null &&
        e.response?.data is Map &&
        e.response?.data['message'] != null) {
      return e.response?.data['message'];
    }
    return e.message ?? 'Unknown error';
  }
}
