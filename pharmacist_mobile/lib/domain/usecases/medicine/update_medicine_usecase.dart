import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/update_medicine.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';

class UpdateMedicineUseCase {
  final MedicineRepository repository;

  UpdateMedicineUseCase(this.repository);

  Future<Either<Failure, UpdateMedicine>> call(UpdateMedicine medicine) {
    return repository.updateMedicine(medicine);
  }
}
