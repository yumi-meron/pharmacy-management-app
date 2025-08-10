import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/domain/entities/cart_item.dart';
import 'package:pharmacist_mobile/domain/repositories/cart_repository.dart';
import '../../../core/error/failure.dart';

class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  Future<Either<Failure, List<CartItem>>> call() {
    return repository.getCartItems();
  }
}