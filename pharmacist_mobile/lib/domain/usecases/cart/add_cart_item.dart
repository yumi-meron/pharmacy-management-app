import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/domain/repositories/cart_repository.dart';
import '../../../core/error/failure.dart';

class AddCartItem {
  final CartRepository repository;

  AddCartItem(this.repository);

  Future<Either<Failure, Unit>> call(String medicineVariantId, int quantity) {
    return repository.addCartItem(medicineVariantId, quantity);
  }
}
