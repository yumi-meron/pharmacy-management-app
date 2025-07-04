import 'package:equatable/equatable.dart';

class MedicineVariant extends Equatable {
  final String id;
  final String medicineId;
  final String brand;
  final String barcode;
  final String unit;
  final double pricePerUnit;
  final DateTime expiryDate;
  final int quantityAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MedicineVariant({
    required this.id,
    required this.medicineId,
    required this.brand,
    required this.barcode,
    required this.unit,
    required this.pricePerUnit,
    required this.expiryDate,
    required this.quantityAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [id, medicineId, brand, barcode, unit, pricePerUnit, expiryDate, quantityAvailable, createdAt, updatedAt];
}