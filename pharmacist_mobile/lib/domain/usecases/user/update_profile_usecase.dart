import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';
import 'package:pharmacist_mobile/domain/repositories/user_repository.dart';

class UpdateProfile {
  final UserRepository repository;

  UpdateProfile(this.repository);

  Future<Either<Failure, User>> call(UpdateProfileParams params) {
    return repository.updateProfile(params.user, params.pictureFile);
  }
}

class UpdateProfileParams {
  final User user;
  final File? pictureFile;

  UpdateProfileParams({required this.user, this.pictureFile});
}
