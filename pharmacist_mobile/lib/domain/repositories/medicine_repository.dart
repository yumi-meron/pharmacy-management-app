import 'package:pharmacist_mobile/domain/entities/medicine.dart';

abstract class MedicineRepository {
  Future<List<Medicine>> searchMedicines(String query);
  Future<Medicine> getMedicineDetails(String id); // Returns Medicine with its variants
}