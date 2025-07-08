import 'dart:io';

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
      try {
        final user = await remoteDataSource.signIn(phoneNumber, password);
        return Right(user);
      } on SocketException {
        return const Left(ConnectionFailure('Failed to connect to the network'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.forgotPassword(phoneNumber);
        return const Right(null);
      } on SocketException {
        return const Left(ConnectionFailure('Failed to connect to the network'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }
}
