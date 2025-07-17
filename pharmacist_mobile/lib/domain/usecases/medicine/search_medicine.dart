import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';

class SearchMedicines {
  final MedicineRepository repository;

  SearchMedicines(this.repository);

  Future<Either<Failure, List<Medicine>>> call(String query) {
    return repository.searchMedicines(query);
  }
}