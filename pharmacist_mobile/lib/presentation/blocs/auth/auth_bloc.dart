import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';
// import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/data/models/user_model.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';
import 'package:pharmacist_mobile/domain/usecases/auth/forgot_password.dart';
import 'package:pharmacist_mobile/domain/usecases/auth/sign_in.dart';
// import 'package:pharmacist_mobile/domain/usecases/auth/request_otp.dart';
import 'package:pharmacist_mobile/domain/usecases/auth/verify_otp.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final ForgotPassword forgotPassword;
  // final RequestOtp requestOtp;
  final VerifyOtp verifyOtp;
  final _storage = const FlutterSecureStorage();

  AuthBloc({
    required this.signIn,
    required this.forgotPassword,
    // required this.requestOtp,
    required this.verifyOtp,
  }) : super(AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<ForgotPasswordEvent>(_onForgotPassword);
    // on<RequestOtpEvent>(_onRequestOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<AuthLoggedOut>(_onLoggedOut);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<UpdateAuthenticatedUser>((event, emit) {
      final currentState = state;
      if (currentState is AuthAuthenticated) {
        emit(AuthAuthenticated(event.user));
      }
    });
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _storage.read(key: "auth_token");
    if (token != null) {
      getIt<Dio>().options.headers['Authorization'] = 'Bearer $token';
    }

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
    final result = await signIn(event.phone, event.password);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// Send phone + newPassword to server — server sends OTP to phone
  Future<void> _onForgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await forgotPassword(event.phone, event.newPassword);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(AuthOtpRequested()),
    );
  }

  // Future<void> _onRequestOtp(RequestOtpEvent event, Emitter<AuthState> emit) async {
  //   emit(AuthLoading());
  //   final result = await requestOtp(event.phone);
  //   result.fold(
  //     (failure) => emit(AuthError(_mapFailureToMessage(failure))),
  //     (_) => emit(AuthOtpRequested()),
  //   );
  // }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await verifyOtp(event.phone, event.otp);
    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (_) => emit(AuthOtpVerified()),
    );
  }

  Future<void> _onLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) async {
    await _storage.delete(key: "auth_token");
    await _storage.delete(key: "user");
    getIt<Dio>().options.headers.remove('Authorization');

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
