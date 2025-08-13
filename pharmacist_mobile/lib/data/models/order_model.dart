import '../../domain/entities/order.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required String id,
    required String hospitalName,
    required String patientName,
    required DateTime orderDate,
    required String status,
  }) : super(
          id: id,
          hospitalName: hospitalName,
          patientName: patientName,
          orderDate: orderDate,
          status: status,
        );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      hospitalName: json['hospital_name'] as String,
      patientName: json['patient_name'] as String,
      orderDate: DateTime.parse(json['order_date'] as String),
      status: json['status'] as String,
    );
  }

  OrderEntity toEntity() => this;
}
