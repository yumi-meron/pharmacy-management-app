import 'package:pharmacist_mobile/domain/entities/update_medicine.dart';

class UpdateMedicineModel extends UpdateMedicine {
  const UpdateMedicineModel({
    required super.id,
    required super.variantid,
    required super.name,
    required super.description,
    required super.barcode,
    required super.unit,
    required super.brand,
    required super.price,
    required super.quantityAvailable,
    required super.imageUrl,
    required super.expiryDate,
  });

  factory UpdateMedicineModel.fromJson(Map<String, dynamic> json) {
    return UpdateMedicineModel(
      id: json['id'],
      variantid: json['variantid'],
      name: json['name'],
      description: json['description'],
      barcode: json['barcode'],
      unit: json['unit'],
      brand: json['brand'],
      price: (json['price'] as num).toDouble(),
      quantityAvailable: json['quantityAvailable'],
      imageUrl: json['imageUrl'],
      expiryDate: json['expiryDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variantid': variantid,
      'name': name,
      'description': description,
      'barcode': barcode,
      'unit': unit,
      'brand': brand,
      'price': price,
      'quantityAvailable': quantityAvailable,
      'imageUrl': imageUrl,
      'expiryDate': expiryDate,
    };
  }
}
