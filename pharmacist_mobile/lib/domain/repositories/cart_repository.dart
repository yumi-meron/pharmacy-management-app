import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/domain/entities/cart_data_entity.dart';
import '../../../core/error/failure.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, CartData>> getCartItems();
  Future<Either<Failure, Unit>> removeCartItem(String id);
  Future<Either<Failure, Unit>> addCartItem(String medicineVariantId, int quantity);
  Future<Either<Failure, Unit>> checkoutCart();

}
