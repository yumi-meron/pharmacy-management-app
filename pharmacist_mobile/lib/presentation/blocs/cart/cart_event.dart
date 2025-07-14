abstract class CartEvent {}

class AddItemToCart extends CartEvent {
  final String itemId;

  AddItemToCart(this.itemId);
}

class RemoveItemFromCart extends CartEvent {
  final String itemId;

  RemoveItemFromCart(this.itemId);
}

class ClearCart extends CartEvent {}
