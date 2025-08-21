import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/domain/entities/update_medicine.dart';
import '../../core/error/failure.dart';
import '../entities/medicine.dart';

abstract class MedicineRepository {
  Future<Either<Failure, List<Medicine>>> searchMedicines(String query);
  Future<Either<Failure, Medicine>> getMedicineDetails(String id);
  Future<Either<Failure, List<Medicine>>> getAllMedicines();
  Future<Either<Failure, UpdateMedicine>> updateMedicine(UpdateMedicine medicine);
}
