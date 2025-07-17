import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/core/network/network_info.dart';
import 'package:pharmacist_mobile/data/datasources/medicine_remote_data_source.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  MedicineRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Medicine>>> searchMedicines(String query) async {
    if (await networkInfo.isConnected) {
      return await dataSource.searchMedicines(query);
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Medicine>> getMedicineDetails(String id) async {
    if (await networkInfo.isConnected) {
      return await dataSource.getMedicineDetails(id);
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }
}
