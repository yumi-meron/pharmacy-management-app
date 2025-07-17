import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/medicine.dart';

abstract class MedicineRepository {
  Future<Either<Failure, List<Medicine>>> searchMedicines(String query);
  Future<Either<Failure, Medicine>> getMedicineDetails(String id);
  Future<Either<Failure, List<Medicine>>> getAllMedicines();
}
