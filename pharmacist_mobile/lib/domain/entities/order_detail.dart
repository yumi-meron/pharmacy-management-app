import 'package:equatable/equatable.dart';
import 'order_item.dart';
import 'patient.dart';

class OrderDetail extends Equatable {
  final String id;
  final Patient patient;
  final List<OrderItem> items;
  final int totalPrice;

  const OrderDetail({
    required this.id,
    required this.patient,
    required this.items,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [id, patient, items, totalPrice];
}
