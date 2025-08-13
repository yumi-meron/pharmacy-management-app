import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrdersEvent extends OrdersEvent {}

class LoadOrderDetailEvent extends OrdersEvent {
  final String id;
  const LoadOrderDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class RequestOrderOtpEvent extends OrdersEvent {
  final String id;
  final String phoneNumber;
  const RequestOrderOtpEvent({required this.id, required this.phoneNumber});

  @override
  List<Object?> get props => [id, phoneNumber];
}

class VerifyOrderOtpEvent extends OrdersEvent {
  final String id;
  final String otp;
  const VerifyOrderOtpEvent({required this.id, required this.otp});

  @override
  List<Object?> get props => [id, otp];
}

