import 'package:equatable/equatable.dart';

abstract class MedicineEvent extends Equatable {
  const MedicineEvent();

  @override
  List<Object> get props => [];
}

class SearchMedicines extends MedicineEvent {
  final String query;

  const SearchMedicines(this.query);

  @override
  List<Object> get props => [query];
}

class FetchAllMedicines extends MedicineEvent {
  const FetchAllMedicines();
}

class FetchMedicineDetails extends MedicineEvent {
  final String id;

  const FetchMedicineDetails(this.id);

  @override
  List<Object> get props => [id];
}

class GetMedicineDetailsEvent extends MedicineEvent {
  final String medicineId;

  final String id;

  const GetMedicineDetailsEvent(this.medicineId) : id = medicineId;

  @override
  List<Object> get props => [medicineId];
}
