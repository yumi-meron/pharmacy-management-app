import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/orders_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/orders_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/orders_state.dart';
import 'package:pharmacist_mobile/presentation/pages/order_detail_page.dart';


class OrdersListPage extends StatefulWidget {
  const OrdersListPage({Key? key}) : super(key: key);

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(LoadOrdersEvent()); // Trigger API call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return const Center(child: Text('No orders found.'));
            }
            return ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  // title: Text('Order #${order.id}'),
                  title: Text('Order for ${order.patientName}'),

                  subtitle: Text(
                    'Date: ${order.orderDate} ',
                  ),
                  trailing: Text(order.status ,
                      style: TextStyle(
                        color: order.status == 'confirmed'
                            ? Colors.green
                            : Colors.orange,
                      )),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailPage(orderId: order.id),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is OrdersError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
