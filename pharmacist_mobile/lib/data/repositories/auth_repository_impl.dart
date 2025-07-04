import 'package:pharmacist_mobile/data/datasources/auth_remote_data_source.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';
import 'package:pharmacist_mobile/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> signIn(String phoneNumber, String password) async {
    return await remoteDataSource.signIn(phoneNumber, password);
  }

  @override
  Future<void> forgotPassword(String phoneNumber) async {
    await remoteDataSource.forgotPassword(phoneNumber);
  }
}