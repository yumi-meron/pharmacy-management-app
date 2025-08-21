import 'package:equatable/equatable.dart';

abstract class OtpVerifyState extends Equatable {
  const OtpVerifyState();

  @override
  List<Object?> get props => [];
}
class OtpVerifyInitial extends OtpVerifyState {}
class OtpRequestSuccess extends OtpVerifyState {}
class OtpRequestLoading extends OtpVerifyState{}
class OtpVerifyLoading extends OtpVerifyState{}


class OtpVerifySuccess extends OtpVerifyState {}

class OtpVerifyError extends OtpVerifyState{
  final String message;
  const OtpVerifyError(this.message);

  @override
  List<Object?> get props => [message];
}