import 'package:equatable/equatable.dart';
import 'medicine_variant.dart'; 

class Medicine extends Equatable {
  final String id;
  final String name;
  final String category;
  final String? description;
  final DateTime createdAt;
  final String picture; // Added for image URL
  final List<MedicineVariant> variants; // Added to handle variants

  const Medicine({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    required this.createdAt,
    required this.picture,
    required this.variants,
  });

  @override
  List<Object?> get props => [id, name, category, description, createdAt, picture, variants];
}