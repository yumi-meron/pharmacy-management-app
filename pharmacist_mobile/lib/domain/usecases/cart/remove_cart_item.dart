import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/domain/repositories/cart_repository.dart';
import '../../../core/error/failure.dart';


class RemoveCartItem {
  final CartRepository repository;

  RemoveCartItem(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.removeCartItem(id);
  }
}
