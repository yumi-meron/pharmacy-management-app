import 'package:dartz/dartz.dart';
import '../../repositories/orders_repository.dart';
import '../../../core/error/failure.dart';

class VerifyOrderOtp {
  final OrdersRepository repository;
  VerifyOrderOtp(this.repository);

  Future<Either<Failure, Unit>> call(String id, String otp) {
    return repository.verifyOrderOtp(id, otp);
  }
}
