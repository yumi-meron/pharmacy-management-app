import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required String medicineName,
    required String unit,
    required int quantity,
    required int pricePerUnit,
  }) : super(
          medicineName: medicineName,
          unit: unit,
          quantity: quantity,
          pricePerUnit: pricePerUnit,
        );

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      medicineName: json['medicine_name'] as String,
      unit: json['unit'] as String,
      quantity: (json['quantity'] as num).toInt(),
      pricePerUnit: (json['price_per_unit'] as num).toInt(),
    );
  }

  OrderItem toEntity() => this;
}
