// domain/usecases/get_cart_items.dart
import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/error/failure.dart';
import 'package:pharmacist_mobile/domain/entities/cart_data_entity.dart';
import 'package:pharmacist_mobile/domain/repositories/cart_repository.dart';


class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  Future<Either<Failure, CartData>> call() {
    return repository.getCartItems();
  }
}
