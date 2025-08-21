import 'package:equatable/equatable.dart';

class UpdateMedicine extends Equatable {
  final String id;
  final String variantid;
  final String name;
  final String description;
  final String barcode;
  final String unit;
  final String brand;
  final double price;
  final int quantityAvailable;
  final String imageUrl;
  final String expiryDate;

  const UpdateMedicine({
    required this.id,
    required this.variantid,
    required this.name,
    required this.description,
    required this.barcode,
    required this.unit,
    required this.brand,
    required this.price,
    required this.quantityAvailable,
    required this.imageUrl,
    required this.expiryDate,
  });

  @override
  List<Object> get props => [
        id,
        variantid,
        name,
        description,
        barcode,
        unit,
        brand,
        price,
        quantityAvailable,
        imageUrl,
        expiryDate,
      ];
}
