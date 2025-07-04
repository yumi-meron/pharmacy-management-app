
import 'package:pharmacist_mobile/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> signIn(String phoneNumber, String password);
  Future<void> forgotPassword(String phoneNumber);
}