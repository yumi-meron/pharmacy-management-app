import 'package:equatable/equatable.dart';
import 'package:pharmacist_mobile/domain/entities/order.dart';
import 'package:pharmacist_mobile/domain/entities/order_detail.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderEntity> orders;
  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderDetailLoading extends OrdersState {}

class OrderDetailLoaded extends OrdersState {
  final OrderDetail detail;
  const OrderDetailLoaded(this.detail);

  @override
  List<Object?> get props => [detail];
}
class OrderDetailError extends OrdersState {
  final String message;
  const OrderDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
class OtpRequestSuccess extends OrdersState {}

class OtpVerifySuccess extends OrdersState {}

class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}
