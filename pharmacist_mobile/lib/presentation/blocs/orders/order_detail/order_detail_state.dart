import 'package:equatable/equatable.dart';
import 'package:pharmacist_mobile/domain/entities/order_detail.dart';

abstract class OrderDetailState extends Equatable {
  const OrderDetailState();

  @override
  List<Object?> get props => [];
}
class OrderDetailLoading extends OrderDetailState {}

class OrderDetailLoaded extends OrderDetailState {
  final OrderDetail detail;
  const OrderDetailLoaded(this.detail);

  @override
  List<Object?> get props => [detail];
}
class OrderDetailInitial extends OrderDetailState {}
class OrderDetailError extends OrderDetailState {
  final String message;
  const OrderDetailError(this.message);

  @override
  List<Object?> get props => [message];
}