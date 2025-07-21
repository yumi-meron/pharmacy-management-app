import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/data/datasources/employee_remote_datasource.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';
import 'package:pharmacist_mobile/domain/repositories/employee_repository.dart';


class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeDataSource dataSource;

  EmployeeRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<User>>> getAllEmployees() async {
    try {
      final employees = await dataSource.fetchEmployees();
      return employees;
    } catch (e) {
      return const Left(ServerFailure('Failed to load employees'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addEmployee({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String role,
  }) async {
    try {
      return await dataSource.createEmployee(
        fullName: fullName,
        phoneNumber: phoneNumber,
        password: password,
        role: role,
      );
    } catch (e) {
      return Left(ServerFailure('Failed to add employee: ${e.toString()}'));
    }
  }
}

