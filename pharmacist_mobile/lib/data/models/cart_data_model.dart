// data/models/cart_data_model.dart
import 'dart:typed_data';

import 'package:pharmacist_mobile/domain/entities/cart_data_entity.dart';
import 'cart_item_model.dart';

class CartDataModel extends CartData {
  CartDataModel({
    required List<CartItemModel> items,
    required double totalPrice,
  }) : super(items: items, totalPrice: totalPrice);

  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    // final items = (json['items'] as List<dynamic>? ?? [])
    //     .map((e) => CartItemModel.fromJson(e));
    // print('asdfghnjmk,$items');
    return CartDataModel(
      items: (json['items'] as List? ?? [])
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
