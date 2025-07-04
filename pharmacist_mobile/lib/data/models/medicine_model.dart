import 'package:pharmacist_mobile/domain/entities/medicine.dart';
import 'package:pharmacist_mobile/domain/entities/medicine_variant.dart';

class MedicineModel {
  final String id;
  final String name;
  final String category;
  final String? description;
  final DateTime createdAt;
  final String picture;
  final List<MedicineVariantModel> variants;

  MedicineModel({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    required this.createdAt,
    required this.picture,
    required this.variants,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      picture: json['picture'],
      variants: (json['variants'] as List<dynamic>?)
          ?.map((v) => MedicineVariantModel.fromJson(v))
          .toList() ?? [],
    );
  }

  Medicine toEntity() => Medicine(
        id: id,
        name: name,
        category: category,
        description: description,
        createdAt: createdAt,
        picture: picture,
        variants: variants.map((v) => v.toEntity()).toList(),
      );
}

class MedicineVariantModel {
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

  MedicineVariantModel({
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

  factory MedicineVariantModel.fromJson(Map<String, dynamic> json) {
    return MedicineVariantModel(
      id: json['id'],
      medicineId: json['medicine_id'],
      brand: json['brand'],
      barcode: json['barcode'],
      unit: json['unit'],
      pricePerUnit: json['price_per_unit'].toDouble(),
      expiryDate: DateTime.parse(json['expiry_date']),
      quantityAvailable: json['quantity_available'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  MedicineVariant toEntity() => MedicineVariant(
        id: id,
        medicineId: medicineId,
        brand: brand,
        barcode: barcode,
        unit: unit,
        pricePerUnit: pricePerUnit,
        expiryDate: expiryDate,
        quantityAvailable: quantityAvailable,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}