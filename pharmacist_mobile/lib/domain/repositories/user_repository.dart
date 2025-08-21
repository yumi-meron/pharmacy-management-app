import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> updateProfile(User user, File? pictureFile);
}
