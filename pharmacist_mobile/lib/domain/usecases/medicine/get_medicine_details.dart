import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';

class GetMedicineDetails {
  final MedicineRepository repository;

  GetMedicineDetails(this.repository);

  Future<Either<Failure, Medicine>> call(String id) {
    return repository.getMedicineDetails(id);
  }
}
