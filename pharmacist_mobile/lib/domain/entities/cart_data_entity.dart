import 'cart_item.dart';

class CartData {
  final List<CartItem> items;
  final double totalPrice;

  CartData({
    required this.items,
    required this.totalPrice,
  });
}
