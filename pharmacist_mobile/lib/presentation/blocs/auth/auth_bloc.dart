import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
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
    final result = await signIn(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onForgotPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await forgotPassword(event.email);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(const AuthForgotPasswordSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ConnectionFailure) {
      return 'No internet connection';
    } else if (failure is ServerFailure) {
      return 'Server error: ${failure.message}';
    } else if (failure is DatabaseFailure) {
      return 'Database error';
    } else {
      return 'Unexpected error: ${failure.message}';
    }
  }
}
