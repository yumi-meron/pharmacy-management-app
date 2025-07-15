class CartState {
  final List<String> items;

  CartState({required this.items});

  int get itemCount => items.length;

  CartState copyWith({List<String>? items}) {
    return CartState(
      items: items ?? this.items,
    );
  }
}
