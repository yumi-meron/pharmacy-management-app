import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/domain/usecases/cart/add_cart_item.dart';
import 'package:pharmacist_mobile/domain/usecases/cart/check_out.dart';
import 'package:pharmacist_mobile/domain/usecases/cart/get_cart_items.dart';
import 'package:pharmacist_mobile/domain/usecases/cart/remove_cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItems getCartItems;
  final RemoveCartItem removeCartItem;
  final AddCartItem addCartItem;
  final CheckoutCart checkoutCart;

  CartBloc({required this.getCartItems, required this.removeCartItem, required this.addCartItem, required this.checkoutCart})
      : super(CartInitial()) {


    on<LoadCart>((event, emit) async {
      emit(CartLoading());

      final result = await getCartItems();

      result.fold(
        (failure) => emit(CartError("Failed to load cart")),
        (cartData) {
          emit(CartLoaded(
            items: cartData.items,
            totalPrice: cartData.totalPrice,
          ));
        },
      );
    });


  on<CheckoutCartEvent>((event, emit) async {
    emit(CartLoading());
    final result = await checkoutCart();
    result.fold(
      (failure) => emit(CartError("Failed to checkout cart")),
      (_) => emit(CartCheckoutSuccess()),
    );
  });


  on<AddCartItemEvent>((event, emit) async {
    final result = await addCartItem(event.medicineVariantId, event.quantity);
    result.fold(
      (failure) => emit(CartError("Failed to add item")),
      (_) async {
        // After adding, reload cart
        final reloadResult = await getCartItems();
        reloadResult.fold(
          (failure) => emit(CartError("Failed to load cart")),
          (cartData) {
            emit(CartLoaded(
              items: cartData.items,
              totalPrice: cartData.totalPrice,
            ));
          },
        );
      },
    );
  });


    on<RemoveCartItemEvent>((event, emit) async {
      if (state is CartLoaded) {
        final currentState = state as CartLoaded;
        final result = await removeCartItem(event.id);
        result.fold(
          (failure) => emit(CartError("Failed to remove item")),
          (_) {
            final updatedItems = currentState.items.where((item) => item.id != event.id).toList();
            final newTotal = updatedItems.fold(0.0, (sum, e) => sum + e.price);
            emit(CartLoaded(items: updatedItems, totalPrice: newTotal));
          },
        );
      }
    });
  }
}
