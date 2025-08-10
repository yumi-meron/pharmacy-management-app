import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id; // medicine_variant_id
  final String name;
  final int price;
  final String unit;
  final String imageUrl;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, price, unit, imageUrl];
}
