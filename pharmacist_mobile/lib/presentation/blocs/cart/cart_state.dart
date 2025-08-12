import 'dart:typed_data';

import 'package:pharmacist_mobile/domain/entities/cart_item.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalPrice;

  CartLoaded({required this.items, required this.totalPrice});
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}
class CartCheckoutSuccess extends CartState {}
class CartCheckoutLoading extends CartState {}
