abstract class EmployeeEvent {}

class FetchEmployees extends EmployeeEvent {}
class AddEmployee extends EmployeeEvent {
  final String name;
  final String phoneNumber;
  final String role;

  AddEmployee({required this.name, required this.phoneNumber, required this.role});
}
