import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn(String phoneNumber, String password);

  /// Initiates forgot-password flow: send newPassword to backend (backend stores it
  /// pending OTP confirmation) and triggers sending OTP to phone.
  Future<Either<Failure, void>> forgotPassword(String phoneNumber, String newPassword);

  /// Resend OTP (if needed)
  // Future<Either<Failure, void>> requestOtp(String phoneNumber);

  /// Verify OTP (finalize password reset)
  Future<Either<Failure, void>> verifyOtp(String phoneNumber, String otp);
}
