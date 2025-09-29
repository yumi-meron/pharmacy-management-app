import 'package:equatable/equatable.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInEvent extends AuthEvent {
  final String phone;
  final String password;
  const SignInEvent(this.phone, this.password);

  @override
  List<Object?> get props => [phone, password];
}

/// Now includes newPassword: we send phone + newPassword to backend to request OTP
class ForgotPasswordEvent extends AuthEvent {
  final String phone;
  final String newPassword;
  const ForgotPasswordEvent(this.phone, this.newPassword);

  @override
  List<Object?> get props => [phone, newPassword];
}

// class RequestOtpEvent extends AuthEvent {
//   final String phone;
//   const RequestOtpEvent(this.phone);

//   @override
//   List<Object?> get props => [phone];
// }

class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;
  const VerifyOtpEvent(this.phone, this.otp);

  @override
  List<Object?> get props => [phone, otp];
}

class AuthLoggedOut extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class UpdateAuthenticatedUser extends AuthEvent {
  final User user;
  const UpdateAuthenticatedUser(this.user);

  @override
  List<Object?> get props => [user];
}
