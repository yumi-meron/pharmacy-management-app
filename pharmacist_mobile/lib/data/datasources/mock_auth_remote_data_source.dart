import 'package:pharmacist_mobile/data/datasources/auth_remote_data_source.dart';
import 'package:pharmacist_mobile/data/models/user_model.dart';

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<UserModel> signIn(String phoneNumber, String password) async {
    // Simulate a successful sign-in for specific credentials
    if (phoneNumber == '1234567890' && password == 'password') {
      return const UserModel(
        id: 1,
        username: 'test_user',
        role: 'pharmacist',
        pharmacyId: 1,
      );
    }
    throw Exception('Invalid phone number or password');
  }

  @override
  Future<void> forgotPassword(String phoneNumber) async {
    // Simulate a successful forgot password request
    if (phoneNumber == '1234567890') {
      return; // Success
    }
    throw Exception('Phone number not found');
  }
}