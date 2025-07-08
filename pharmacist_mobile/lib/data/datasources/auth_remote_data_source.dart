import 'package:dio/dio.dart';
import 'package:pharmacist_mobile/core/constants/api_constants.dart';
import 'package:pharmacist_mobile/core/error/server_error.dart';
import 'package:pharmacist_mobile/data/models/user_model.dart';


abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String phoneNumber, String password);
  Future<void> forgotPassword(String phoneNumber);
}

class RemoteDataSourceImpl extends AuthRemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> signIn(String phoneNumber, String password) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.signIn}',
        data: {'phone_number': phoneNumber, 'password': password},
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException('Failed to sign in: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Failed to sign in: ${e.toString()}');
    }
  }

  @override
  Future<void> forgotPassword(String phoneNumber) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.forgotPassword}',
        data: {'phone_number': phoneNumber},
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException('Failed to process forgot password: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Failed to process forgot password: ${e.toString()}');
    }
  }
}