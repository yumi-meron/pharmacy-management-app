import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn(String phoneNumber, String password);
  Future<Either<Failure, void>> forgotPassword(String phoneNumber);
}
