import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String hospitalName;
  final String patientName;
  final DateTime orderDate;
  final String status;

  const OrderEntity({
    required this.id,
    required this.hospitalName,
    required this.patientName,
    required this.orderDate,
    required this.status,
  });

  @override
  List<Object?> get props => [id, hospitalName, patientName, orderDate, status];

 
}
