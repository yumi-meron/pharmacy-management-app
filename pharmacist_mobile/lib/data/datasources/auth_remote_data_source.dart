import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pharmacist_mobile/core/constants/api_constants.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> signIn(
      String phoneNumber, String password);
  Future<Either<Failure, void>> forgotPassword(String phoneNumber);
}

class RemoteDataSourceImpl extends AuthRemoteDataSource {
  final Dio dio;
  final SharedPreferences prefs;

  RemoteDataSourceImpl({required this.dio, required this.prefs});

  @override
  Future<Either<Failure, UserModel>> signIn(
      String phoneNumber, String password) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.signIn}',
        data: {'phone_number': phoneNumber, 'password': password},
      );

      if (response.statusCode == 200 && response.data['user'] != null) {
        final user = UserModel.fromJson(response.data['user']);

        // Save user as JSON
        await prefs.setString('user', jsonEncode(user.toJson()));
        
        // Save the token
        final token = response.data['token'];
        if (token != null) {
          await prefs.setString('token', token);
        }

        return Right(user);
      } else {
        return Left(ServerFailure('Failed to sign in: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String phoneNumber) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.forgotPassword}',
        data: {'phone_number': phoneNumber},
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure(
            'Failed to process forgot password: ${response.statusCode}'));
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
