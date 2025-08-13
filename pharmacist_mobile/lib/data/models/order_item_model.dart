import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required String id,
    required String medicineName,
    required String unit,
    required int quantity,
    required int pricePerUnit,
  }) : super(
          id: id,
          medicineName: medicineName,
          unit: unit,
          quantity: quantity,
          pricePerUnit: pricePerUnit,
        );

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      medicineName: json['medicine_name'] as String,
      unit: json['unit'] as String,
      quantity: (json['quantity'] as num).toInt(),
      pricePerUnit: (json['price_per_unit'] as num).toInt(),
    );
  }

  OrderItem toEntity() => this;
}
