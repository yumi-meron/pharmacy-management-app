import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';
import 'package:pharmacist_mobile/presentation/blocs/cart/cart_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/cart/cart_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/cart/cart_state.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CartBloc>()..add(LoadCart()),
      child: Scaffold(
        appBar: AppBar(title: Text("Your cart")),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) return Center(child: CircularProgressIndicator());
            if (state is CartError) return Center(child: Text(state.message));
            if (state is CartLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return ListTile(
                          leading: Image.network(item.imageUrl),
                          title: Text(item.name),
                          subtitle: Text('${item.unit} — ${item.price} ETB'),
                          trailing: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              context.read<CartBloc>().add(RemoveCartItemEvent(item.id));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total : ${state.totalPrice} ETB'),
                        ElevatedButton(
                          onPressed: () {
                            // Handle checkout
                          },
                          child: Text('Check Out'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
