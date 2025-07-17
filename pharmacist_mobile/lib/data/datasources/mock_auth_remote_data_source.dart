import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/data/datasources/auth_remote_data_source.dart';
import 'package:pharmacist_mobile/data/models/user_model.dart';

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<Either<Failure, UserModel>> signIn(String phoneNumber, String password) async {
    if (phoneNumber == '1234567890' && password == 'password') {
      return const Right(UserModel(
        id: '1',
        name: "meron",
        phoneNumber: 'test_user',
        role: 'pharmacist',
        pharmacyId: '1',
        picture: 'https://i.pravatar.cc/150?img=12',
      ));
    } else {
      return const Left(ServerFailure('Invalid phone number or password'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String phoneNumber) async {
    if (phoneNumber == '1234567890') {
      return const Right(null);
    } else {
      return const Left(ServerFailure('Phone number not found'));
    }
  }
}
