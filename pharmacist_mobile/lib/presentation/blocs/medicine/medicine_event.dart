import 'package:equatable/equatable.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';
import 'package:pharmacist_mobile/domain/entities/update_medicine.dart';

abstract class MedicineEvent extends Equatable {
  const MedicineEvent();

  @override
  List<Object> get props => [];
}

class ScanBarcodeEvent extends MedicineEvent {
  final String barcode;
  const ScanBarcodeEvent(this.barcode);

  @override
  List<Object> get props => [barcode];
}


class SearchMedicines extends MedicineEvent {
  final String query;

  const SearchMedicines(this.query);

  @override
  List<Object> get props => [query];
}

class UpdateMedicineEvent extends MedicineEvent {
  final UpdateMedicine medicine;

  const UpdateMedicineEvent({required this.medicine});

  @override
  List<Object> get props => [medicine];
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
class AlreadyFetchedMedicineEvent extends MedicineEvent {
  final Medicine medicine;

  const AlreadyFetchedMedicineEvent(this.medicine);

  @override
  List<Object> get props => [medicine];
}


class GetMedicineDetailsEvent extends MedicineEvent {
  final String medicineId;

  final String id;

  const GetMedicineDetailsEvent(this.medicineId) : id = medicineId;

  @override
  List<Object> get props => [medicineId];
}
