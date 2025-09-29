import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/core/network/network_info.dart';
import 'package:pharmacist_mobile/data/datasources/auth_remote_data_source.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';
import 'package:pharmacist_mobile/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signIn(String phoneNumber, String password) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.signIn(phoneNumber, password);
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String phoneNumber, String newPassword) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.forgotPassword(phoneNumber, newPassword);
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }

  // @override
  // Future<Either<Failure, void>> requestOtp(String phoneNumber) async {
  //   if (await networkInfo.isConnected) {
  //     return await remoteDataSource.requestOtp(phoneNumber);
  //   } else {
  //     return const Left(ConnectionFailure('No internet connection'));
  //   }
  // }

  @override
  Future<Either<Failure, void>> verifyOtp(String phoneNumber, String otp) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.verifyOtp(phoneNumber, otp);
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }
}
