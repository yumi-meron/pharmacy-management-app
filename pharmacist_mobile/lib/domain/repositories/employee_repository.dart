import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<User>>> getAllEmployees();
  Future<Either<Failure, Unit>> addEmployee({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String role,
  });
}