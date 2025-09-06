import 'package:equatable/equatable.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
class SignedIn extends AuthEvent {
  final String token;
  const SignedIn(this.token);
}
class UpdateAuthenticatedUser extends AuthEvent {
  final User user;
  UpdateAuthenticatedUser(this.user);
}
class AuthCheckRequested extends AuthEvent {}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent(this.email);

  @override
  List<Object> get props => [email];
}

class AuthLoggedOut extends AuthEvent {
  const AuthLoggedOut();
  
}