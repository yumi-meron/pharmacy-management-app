import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';
import 'package:pharmacist_mobile/domain/repositories/auth_repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<Either<Failure, User>> call(String phoneNumber, String password) async {
    return await repository.signIn(phoneNumber, password);
  }
}
