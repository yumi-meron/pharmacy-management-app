import 'package:pharmacist_mobile/data/datasources/medicine_remote_data_source.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineRemoteDataSource dataSource;

  MedicineRepositoryImpl(this.dataSource);

  @override
  Future<List<Medicine>> searchMedicines(String query) async {
    return await dataSource.searchMedicines(query);
  }

  @override
  Future<Medicine> getMedicineDetails(String id) async {
    return await dataSource.getMedicineDetails(id);
  }
}