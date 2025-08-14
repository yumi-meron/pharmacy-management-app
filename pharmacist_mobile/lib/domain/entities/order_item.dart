import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String id;
  final String medicineName;
  final String unit;
  final int quantity;
  final int pricePerUnit;

  const OrderItem({
    required this.id,
    required this.medicineName,
    required this.unit,
    required this.quantity,
    required this.pricePerUnit,
  });

  @override
  List<Object?> get props => [id, medicineName, unit, quantity, pricePerUnit];
}
