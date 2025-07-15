import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(items: [])) {
    on<AddItemToCart>((event, emit) {
      final updatedItems = List<String>.from(state.items)..add(event.itemId);
      emit(state.copyWith(items: updatedItems));
    });

    on<RemoveItemFromCart>((event, emit) {
      final updatedItems = List<String>.from(state.items)..remove(event.itemId);
      emit(state.copyWith(items: updatedItems));
    });

    on<ClearCart>((event, emit) {
      emit(state.copyWith(items: []));
    });
  }
}
