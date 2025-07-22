abstract class EmployeeEvent {}

class FetchEmployees extends EmployeeEvent {}
class AddEmployee extends EmployeeEvent {
  final String name;
  final String phoneNumber;
  final String role;
  final String password;

  AddEmployee({required this.name, required this.phoneNumber, required this.role, required this.password});
}
