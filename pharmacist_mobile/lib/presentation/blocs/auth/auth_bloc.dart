import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/data/models/user_model.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';
import 'package:pharmacist_mobile/domain/usecases/auth/forgot_password.dart';
import 'package:pharmacist_mobile/domain/usecases/auth/sign_in.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final ForgotPassword forgotPassword;
  final _storage = const FlutterSecureStorage();

  AuthBloc({required this.signIn, required this.forgotPassword})
      : super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<AuthLoggedOut>(_onLoggedOut);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<UpdateAuthenticatedUser>((event, emit) {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      // Emit new state with updated user
      emit(AuthAuthenticated(event.user));
    }
  });
  }
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('checking auth status...');
    final token = await _storage.read(key: "auth_token");

    User? user;
    final userJson = await _storage.read(key: "user");

    if (userJson != null) {
      user = UserModel.fromJson(jsonDecode(userJson)).toEntity();
    }

    if (token != null && user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
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

  Future<void> _onLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) async {
  emit(const AuthUnauthenticated());
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
