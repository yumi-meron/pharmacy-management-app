import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/repositories/auth_repository.dart';

class ForgotPassword {
  final AuthRepository repository;
  ForgotPassword(this.repository);

  Future<Either<Failure, void>> call(String phoneNumber, String newPassword) {
    return repository.forgotPassword(phoneNumber, newPassword);
  }
}
