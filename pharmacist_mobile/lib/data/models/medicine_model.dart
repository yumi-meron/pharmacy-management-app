import 'package:pharmacist_mobile/data/models/medicine_variant_model.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';
import 'package:pharmacist_mobile/domain/entities/medicine_variant.dart';

class MedicineModel {
  final String id;
  final String name;
  final String? category;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String picture;
  final String pharmacyId;
  final List<MedicineVariantModel> variants;

  MedicineModel({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.pharmacyId,
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
      updatedAt: DateTime.parse(json['updated_at']),
      pharmacyId: json['pharmacy_id'],
      picture: json['picture'],
      variants: (json['variants'] as List<dynamic>?)
              ?.map((v) => MedicineVariantModel.fromJson(v))
              .toList() ??
          [],
    );
  }

  Medicine toEntity() => Medicine(
        id: id,
        name: name,
        category: category ?? '',
        description: description,
        createdAt: createdAt,
        updatedAt: updatedAt,
        pharmacyId: pharmacyId,
        picture: picture,
        variants: variants.map((v) => v.toEntity()).toList(),
      );
}
