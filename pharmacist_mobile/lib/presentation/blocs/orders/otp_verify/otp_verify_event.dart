abstract class OtpVerifyEvent {
  const OtpVerifyEvent();

  @override
  List<Object?> get props => [];
}
class OtpVerifyInitialEvent extends OtpVerifyEvent {
  const OtpVerifyInitialEvent();

  @override
  List<Object?> get props => [];
}
class RequestOrderOtpEvent extends OtpVerifyEvent {
  final String id;
  final String phoneNumber;
  const RequestOrderOtpEvent({required this.id, required this.phoneNumber});

  @override
  List<Object?> get props => [id, phoneNumber];
}

class VerifyOrderOtpEvent extends OtpVerifyEvent {
  final String id;
  final String otp;
  const VerifyOrderOtpEvent({required this.id, required this.otp});

  @override
  List<Object?> get props => [id, otp];
}

