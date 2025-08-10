abstract class CartEvent {}

class AddCartItemEvent extends CartEvent {
  final String medicineVariantId;
  final int quantity;

  AddCartItemEvent({required this.medicineVariantId, required this.quantity});
}
class LoadCart extends CartEvent {}


class RemoveCartItemEvent extends CartEvent {
  final String id;

  RemoveCartItemEvent(this.id);
}
class CheckoutCartEvent extends CartEvent {}

class ClearCart extends CartEvent {}
