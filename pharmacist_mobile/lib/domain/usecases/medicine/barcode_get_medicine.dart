import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';

class GetMedicineByBarcode {
  final MedicineRepository repository;

  GetMedicineByBarcode(this.repository);

  Future<Either<Failure, Medicine>> call(String barcode) {
    return repository.getMedicineByBarcode(barcode);
  }
}
