import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/domain/repositories/employee_repository.dart';
import 'package:pharmacist_mobile/presentation/blocs/employee/employee_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/employee/employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository employeeRepository;

  EmployeeBloc(this.employeeRepository) : super(EmployeeInitial()) {
    on<FetchEmployees>((event, emit) async {
      emit(EmployeeLoading());
      final result = await employeeRepository.getAllEmployees();
      result.fold(
        (failure) => emit(EmployeeError(failure.message)),
        (employees) => emit(EmployeeLoaded(employees)),
      );
    });
    on<AddEmployee>((event, emit) async {
    emit(EmployeeLoading());
    final result = await employeeRepository.addEmployee(
      fullName: event.name,
      phoneNumber: event.phoneNumber,
      password: '12345678', // Default password
      role: event.role,
    );

    result.fold(
      (failure) => emit(EmployeeError(failure.message)),
      (_) => emit(EmployeeAddedSuccessfully()),
    );
  });

  }
  
}
