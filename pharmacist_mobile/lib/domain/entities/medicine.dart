import 'package:equatable/equatable.dart';
import 'medicine_variant.dart'; 

class Medicine extends Equatable {
  final String id;
  final String name;
  final String category;
  final String medicineUsage;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String picture; 
  final String pharmacyId;
  final List<MedicineVariant> variants; 

  const Medicine({
    required this.id,
    required this.name,
    required this.category,
    required this.medicineUsage,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.picture,
    required this.pharmacyId,
    required this.variants,
  });

  @override
  List<Object?> get props => [id, name, category, description, createdAt,updatedAt, picture,pharmacyId ,variants];
}