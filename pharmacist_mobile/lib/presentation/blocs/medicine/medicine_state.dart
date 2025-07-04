import 'package:equatable/equatable.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';

abstract class MedicineState extends Equatable {
  const MedicineState();

  @override
  List<Object> get props => [];
}

class MedicineInitial extends MedicineState {}

class MedicineLoading extends MedicineState {}

class MedicineLoaded extends MedicineState {
  final List<Medicine> medicines;

  const MedicineLoaded(this.medicines);

  @override
  List<Object> get props => [medicines];
}

class MedicineDetailsLoaded extends MedicineState {
  final Medicine medicine;

  const MedicineDetailsLoaded(this.medicine);

  @override
  List<Object> get props => [medicine];
}

class MedicineError extends MedicineState {
  final String message;

  const MedicineError(this.message);

  @override
  List<Object> get props => [message];
}