import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/core/network/network_info.dart';
import 'package:pharmacist_mobile/data/datasources/medicine_remote_data_source.dart';
import 'package:pharmacist_mobile/data/models/update_medicine_model.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';
import 'package:pharmacist_mobile/domain/entities/update_medicine.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  MedicineRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

 
  @override
  Future<Either<Failure, Medicine>> getMedicineByBarcode(String barcode) async {
    try {
      final model = await dataSource.getMedicineByBarcode(barcode);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, UpdateMedicine>> updateMedicine(
      UpdateMedicine medicine) async {
    try {
      final model = UpdateMedicineModel(
        id: medicine.id,
        variantid: medicine.variantid,
        name: medicine.name,
        description: medicine.description,
        barcode: medicine.barcode,
        unit: medicine.unit,
        brand: medicine.brand,
        price: medicine.price,
        quantityAvailable: medicine.quantityAvailable,
        imageUrl: medicine.imageUrl,
        expiryDate: medicine.expiryDate,
      );

      final result = await dataSource.updateMedicine(model);
      print(result);

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

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

  @override
  Future<Either<Failure, List<Medicine>>> getAllMedicines() async {
    if (await networkInfo.isConnected) {
      return await dataSource.getAllMedicines();
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }
}
