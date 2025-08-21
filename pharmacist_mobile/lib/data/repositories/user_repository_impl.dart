import 'dart:io';

import 'package:pharmacist_mobile/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';
import 'package:pharmacist_mobile/data/datasources/user_remote_data_source.dart';
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> updateProfile(User user, File? pictureFile) async {
    try {
      final updatedUser = await remoteDataSource.updateProfile(user, pictureFile);
      return Right(updatedUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
