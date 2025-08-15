import 'package:dartz/dartz.dart';
import 'package:pharmacist_mobile/core/network/network_info.dart';
import 'package:pharmacist_mobile/domain/entities/cart_data_entity.dart';
import '../../../core/error/failure.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remote;
    final NetworkInfo networkInfo;


  CartRepositoryImpl(this.remote, this.networkInfo);

 
  @override
  Future<Either<Failure, CartData>> getCartItems() async {
    final result = await remote.getCartItems();

    return result.fold(
      (failure) => Left(failure),
      (cartDataModel) => Right(cartDataModel), 
    );
  }


  @override
  Future<Either<Failure, Unit>> addCartItem(String medicineVariantId, int quantity) async {
    try {
      await remote.addCartItem(medicineVariantId, quantity);
      return Right(unit);
    } catch (_) {
      return Left(ServerFailure('Failed to add cart item'));
    }
  }


  @override
  Future<Either<Failure, Unit>> checkoutCart() async {
    try {
      await remote.checkoutCart();
      return Right(unit);
    } catch (_) {
      return Left(ServerFailure('Failed to checkout cart'));
    }
  }


  @override
  Future<Either<Failure, Unit>> removeCartItem(String id) async {
    try {
      await remote.removeCartItem(id);
      return Right(unit);
    } catch (_) {
      return Left(ServerFailure('Failed to remove cart item'));
    }
  }
}
