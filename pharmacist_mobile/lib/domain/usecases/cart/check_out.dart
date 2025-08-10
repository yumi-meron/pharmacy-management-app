import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/domain/repositories/cart_repository.dart';
import '../../../core/error/failure.dart';

class CheckoutCart {
  final CartRepository repository;

  CheckoutCart(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.checkoutCart();
  }
}
