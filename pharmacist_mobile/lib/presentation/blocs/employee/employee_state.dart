import 'package:pharmacist_mobile/domain/entities/user.dart';

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<User> employees;
  EmployeeLoaded(this.employees);
}

class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);
}
class EmployeeAddedSuccessfully extends EmployeeState {}
