import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:pharmacist_mobile/core/constants/api_constants.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> signIn(String phoneNumber, String password);
  Future<Either<Failure, void>> forgotPassword(String phoneNumber, String newPassword);
  // Future<Either<Failure, void>> requestOtp(String phoneNumber);
  Future<Either<Failure, void>> verifyOtp(String phoneNumber, String otp);
}

class RemoteDataSourceImpl extends AuthRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  RemoteDataSourceImpl({required this.dio, required this.secureStorage});

  @override
  Future<Either<Failure, UserModel>> signIn(String phoneNumber, String password) async {
    await secureStorage.deleteAll();
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.signIn}',
        data: {'phone_number': phoneNumber, 'password': password},
      );

      if (response.statusCode == 200 && response.data['user'] != null) {
        final user = UserModel.fromJson(response.data['user']);

        await secureStorage.write(key: 'user', value: jsonEncode(user.toJson()));

        final token = response.data['token'];
        if (token != null) {
          await secureStorage.write(key: 'auth_token', value: token);
          dio.options.headers['Authorization'] = 'Bearer $token';
        }
      final all = await secureStorage.readAll();
      print("All keys in storage: $all");

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
  Future<Either<Failure, void>> forgotPassword(String phoneNumber, String newPassword) async {
    try {
      // The backend endpoint should accept phone_number and new_password,
      // store the new password pending OTP, and send OTP to phone.
      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.forgotPassword}',
        data: {'phone_number': phoneNumber, 'new_password': newPassword},
      );
      print(response.data);

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Failed to process forgot password: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(_getErrorMessage(e)));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  // @override
  // Future<Either<Failure, void>> requestOtp(String phoneNumber) async {
  //   try {
  //     final response = await dio.post(
  //       '${ApiConstants.baseUrl}${ApiConstants.requestOtp}',
  //       data: {'phone_number': phoneNumber},
  //     );

  //     if (response.statusCode == 200) {
  //       return const Right(null);
  //     } else {
  //       return Left(ServerFailure('Failed to request OTP: ${response.statusCode}'));
  //     }
  //   } on DioException catch (e) {
  //     return Left(ServerFailure(_getErrorMessage(e)));
  //   } catch (e) {
  //     return Left(ServerFailure('Unexpected error: ${e.toString()}'));
  //   }
  // }

  @override
  Future<Either<Failure, void>> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}/auth/reset-password',
        data: {'phone_number': phoneNumber, 'otp': otp},
      );
      print('verifyopt data: ${response.data}');

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Invalid OTP: ${response.statusCode}'));
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
