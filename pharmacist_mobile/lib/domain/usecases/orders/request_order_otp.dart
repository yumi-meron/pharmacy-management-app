import 'package:dartz/dartz.dart';
import '../../repositories/orders_repository.dart';
import '../../../core/error/failure.dart';

class RequestOrderOtp {
  final OrdersRepository repository;
  RequestOrderOtp(this.repository);

  Future<Either<Failure, Unit>> call(String id, String phoneNumber) {
    return repository.requestOrderOtp(id, phoneNumber);
  }
}
