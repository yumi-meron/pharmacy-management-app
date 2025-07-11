import 'dart:io';

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
      try {
        final result = await dataSource.searchMedicines(query);
        return Right(result);
      } on SocketException {
        return const Left(ConnectionFailure('Failed to connect to the network'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Medicine>> getMedicineDetails(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getMedicineDetails(id);
        return Right(result);
      } on SocketException {
        return const Left(ConnectionFailure('Failed to connect to the network'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }
}
