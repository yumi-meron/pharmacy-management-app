import 'package:equatable/equatable.dart';

abstract class OrderDetailEvent extends Equatable {
  const OrderDetailEvent();

  @override
  List<Object?> get props => [];
}
class LoadOrderDetailEvent extends OrderDetailEvent {
  final String id;
  const LoadOrderDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}
