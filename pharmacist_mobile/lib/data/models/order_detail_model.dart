import '../../domain/entities/order_detail.dart';
import 'patient_model.dart';
import 'order_item_model.dart';

class OrderDetailModel extends OrderDetail {
  const OrderDetailModel({
    required String id,
    required patient,
    required items,
    required int totalPrice,
  }) : super(id: id, patient: patient, items: items, totalPrice: totalPrice);

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    final patientJson = json['patient'] as Map<String, dynamic>;
    final itemsJson = (json['items'] as List).cast<Map<String, dynamic>>();

    final patientModel = PatientModel.fromJson(patientJson);
    final items = itemsJson.map((e) => OrderItemModel.fromJson(e)).toList();

    return OrderDetailModel(
      id: json['id'] as String,
      patient: patientModel,
      items: items,
      totalPrice: (json['total_price'] as num).toInt(),
    );
  }

  OrderDetail toEntity() => this;
}
