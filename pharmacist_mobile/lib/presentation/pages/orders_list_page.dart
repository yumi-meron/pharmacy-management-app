import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';
import 'package:pharmacist_mobile/domain/entities/order.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/order_detail/order_detail_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/orders_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/orders_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/orders_state.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/otp_verify/otp_verify_bloc.dart';
import 'package:pharmacist_mobile/presentation/pages/order_detail_page.dart';
import 'package:intl/intl.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({Key? key}) : super(key: key);

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<OrderEntity> _filteredOrders = [];
  List<OrderEntity> _allOrders = [];

  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(LoadOrdersEvent()); // Trigger API call
  }

  void _filterOrders(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOrders = _allOrders;
      } else {
        _filteredOrders = _allOrders.where((order) {
          // Ensure hospitalName and patientName are properly accessed
          final hospitalName = order.hospitalName.toLowerCase();
          return hospitalName.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 24, left: 30, right: 30, bottom: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search orders',
                hintStyle: const TextStyle(
                  fontSize: 14, // Smaller font size for hint text
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20, // Smaller icon size
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10, // Decrease vertical padding for smaller height
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300, // Light grey border color
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey
                        .shade300, // Light grey border color for enabled state

                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey
                        .shade500, // Slightly darker grey for focused state
                  ),
                ),
              ),
              style: const TextStyle(
                fontSize: 14, // Smaller font size for input text
              ),
              onChanged: _filterOrders,
            ),
          ),
          Expanded(
            child: BlocBuilder<OrdersBloc, OrdersState>(
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is OrdersLoaded) {
                  _allOrders = state.orders.cast<OrderEntity>();

                  if (_filteredOrders.isEmpty) {
                    return const Center(
                      child: Text(
                        'No orders found.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(18),
                    itemCount: _filteredOrders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      final hospitalInitials = order.hospitalName
                          .split(' ')
                          .where((word) => word.isNotEmpty)
                          .take(2)
                          .map((word) => word[0])
                          .join()
                          .toUpperCase(); // Extract initials (e.g., "City Health Hospital" -> "CH")

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade100,
                            child: Text(
                              hospitalInitials,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.hospitalName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Patient: ${order.patientName}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                DateFormat('d MMM yyyy')
                                    .format(order.orderDate),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider<OtpVerifyBloc>(
                                      create: (_) => OtpVerifyBloc(
                                        requestOrderOtp: getIt(),
                                        verifyOrderOtp: getIt(),
                                      ),
                                    ),
                                    BlocProvider.value(
                                      value: context.read<OrderDetailBloc>(),
                                    ),
                                  ],
                                  child: OrderDetailPage(orderId: order.id),
                                ),
                              ),
                            );
                          },


                        ),
                      );
                    },
                  );
                } else if (state is OrdersError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
