import 'package:dio/dio.dart';
import 'package:pharmacist_mobile/core/constants/api_constants.dart';
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
    final response = await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.signIn}',
      data: {'phone_number': phoneNumber, 'password': password},
    );
    return UserModel.fromJson(response.data['user']);
  }

  @override
  Future<void> forgotPassword(String phoneNumber) async {
    await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.forgotPassword}',
      data: {'phone_number': phoneNumber},
    );
  }
}