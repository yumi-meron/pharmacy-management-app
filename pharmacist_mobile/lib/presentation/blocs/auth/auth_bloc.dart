import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/domain/usecases/auth/forgot_password.dart';
import 'package:pharmacist_mobile/domain/usecases/auth/sign_in.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final ForgotPassword forgotPassword;

  AuthBloc({required this.signIn, required this.forgotPassword})
      : super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<ForgotPasswordEvent>(_onForgotPassword);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signIn(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onForgotPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await forgotPassword(event.email);
      emit(const AuthForgotPasswordSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}