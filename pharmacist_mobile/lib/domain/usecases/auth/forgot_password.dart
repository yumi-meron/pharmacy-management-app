import 'package:pharmacist_mobile/domain/repositories/auth_repository.dart';

class ForgotPassword {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  Future<void> call(String phoneNumber) async {
    await repository.forgotPassword(phoneNumber);
  }
}