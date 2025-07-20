import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';
import 'package:pharmacist_mobile/domain/usecases/medicine/get_all_medicine.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_state.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';
import 'package:pharmacist_mobile/presentation/pages/inventory_page.dart';
import 'package:pharmacist_mobile/presentation/widgets/medicine_card.dart';
import 'package:pharmacist_mobile/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:pharmacist_mobile/presentation/widgets/pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                final user = state.user;
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.picture),
                      radius: 16,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Hi, Welcome Back',
                            style: TextStyle(fontSize: 12, color: Colors.teal)),
                        Text(user.name, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {},
                    ),
                  ],
                );
              } else {
                return const Text("Love Care Pharmacy");
              }
            },
          ),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: BlocProvider(
                create: (context) => MedicineBloc(
                  getIt(), // Pass the required positional argument
                  repository: getIt(),
                  getMedicineDetails: getIt(),
                )..add(const FetchAllMedicines()),
                child: BlocBuilder<MedicineBloc, MedicineState>(
                  builder: (context, state) {
                    return IndexedStack(
                      index: _selectedIndex,
                      children: [
                        // Home content
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  children: [
                                    const SizedBox(height: 20),
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search...',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      onChanged: (query) => context
                                          .read<MedicineBloc>()
                                          .add(SearchMedicines(query)),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      height: 100,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFF004D40),
                                            Colors.teal,
                                            Color(0xFFB2DFDB),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Love Care',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Pharmacy',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Categories',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 40,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            'Antibiotics',
                                            'Vitamins',
                                            'Pain Relief',
                                            'Cold & Flu'
                                          ]
                                              .map((cat) => Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6.0),
                                                    child: ElevatedButton(
                                                      onPressed: () {},
                                                      child: Text(cat),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Recent Purchases',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if (state is MedicineLoading)
                                      const Center(
                                          child: CircularProgressIndicator())
                                    else if (state is MedicineError)
                                      Text('Error: ${state.message}')
                                    else if (state is MedicineLoaded)
                                      SizedBox(
                                        height: 260,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children:
                                                state.medicines.map((medicine) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: MedicineWidget(
                                                    medicine: medicine),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      )
                                    else
                                      const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const InventoryPage(),
                        const OrdersPage(),
                        const SettingsPage(),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Bottom Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavigationBar(
                selectedIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
            // QR Code Icon
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
