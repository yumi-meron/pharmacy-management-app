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
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Your cart",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading)
              return Center(child: CircularProgressIndicator());
            if (state is CartError) return Center(child: Text(state.message));
            if (state is CartCheckoutSuccess) {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (context) {
                    final height = MediaQuery.of(context).size.height;
                    return Container(
                      height: height * 0.3,
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.verified, color: Colors.teal, size: 70),
                          SizedBox(height: 24),
                          Text(
                            "Cart Checkout Successful",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                );

                context.read<CartBloc>().add(LoadCart());
              // });
            }
            if (state is CartLoaded) {
              if (state.items.isEmpty) {
                return Center(
                  child: Text(
                    'Your cart is empty',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade300, width: 1),
                                ),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: Image.network(
                                        item.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 4),
                                        Text('${item.unit}'),
                                        SizedBox(height: 2),
                                        Text('${item.price} ETB'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.close, size: 14),
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      onPressed: () {
                                        context
                                            .read<CartBloc>()
                                            .add(RemoveCartItemEvent(item.id));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(text: 'Total : '),
                              TextSpan(
                                text: '${state.totalPrice} ETB',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        state is CartCheckoutLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF01C587),
                                  minimumSize: Size(160, 40),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  context
                                      .read<CartBloc>()
                                      .add(CheckoutCartEvent());
                                },
                                label: Text(
                                  'Check Out',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
