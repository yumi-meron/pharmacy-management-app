import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.name,
    required super.price,
    required super.unit,
    required super.imageUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {

    return CartItemModel(
      id: json['id'],
      name: json['medicine_name'],
      price: (json['price'] as num).toDouble(),
      unit: json['unit'],
      imageUrl: json['image_url'],
    );
  }

  CartItem toEntity() {
    return CartItem(
      id: id,
      name: name,
      price: price,
      unit: unit,
      imageUrl: imageUrl,
    );
  }
}
