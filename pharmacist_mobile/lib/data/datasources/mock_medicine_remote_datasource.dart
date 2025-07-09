import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';
import 'package:pharmacist_mobile/domain/repositories/medicine_repository.dart';
import 'package:pharmacist_mobile/data/models/medicine_model.dart';

class MockMedicineRepository implements MedicineRepository {
  List<Medicine>? _cache;

  Future<void> _loadMockData() async {
    if (_cache == null) {
      try {
        final jsonString = await rootBundle.loadString('assets/dummy_medicines.json');
        final decoded = json.decode(jsonString) as List;
        _cache = decoded.map((json) => MedicineModel.fromJson(json).toEntity()).toList();
        print("Loaded ${_cache?.length} medicines");

      } catch (e) {
        throw Exception('Failed to load mock data: $e');
      }
    }
  }

  @override
  Future<Either<Failure, List<Medicine>>> searchMedicines(String query) async {
    try {
      await _loadMockData();
      final result = query.isEmpty
          ? _cache!
          : _cache!.where((m) => m.name.toLowerCase().contains(query.toLowerCase())).toList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Mock error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Medicine>> getMedicineDetails(String id) async {
    try {
      await _loadMockData();
      final medicine = _cache!.firstWhere((m) => m.id == id, orElse: () => throw Exception('Not found'));
      return Right(medicine);
    } catch (e) {
      return Left(ServerFailure('Mock error: ${e.toString()}'));
    }
  }
}
