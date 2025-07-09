import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_state.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';
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
                      const Text('Hi, Welcome Back', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
          // Main content
          SafeArea(
            child: BlocProvider(
              create: (context) => MedicineBloc(getIt())..add(const SearchMedicines('')),
              child: BlocBuilder<MedicineBloc, MedicineState>(
                builder: (context, state) {
                  return IndexedStack(
                    index: _selectedIndex,
                    children: [
                      // Home content
                      Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.all(8.0),
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Search...',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (query) => context.read<MedicineBloc>().add(SearchMedicines(query)),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  color: Colors.teal,
                                  padding: const EdgeInsets.all(10),
                                  child: const Text(
                                    'Love Care Pharmacy',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 40,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: ['Antibiotics', 'Vitamins', 'Pain Relief', 'Cold & Flu']
                                          .map((cat) => Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text(cat),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text('Recent Purchases', style: TextStyle(fontSize: 18)),
                                const SizedBox(height: 10),
                                if (state is MedicineLoading)
                                  const Center(child: CircularProgressIndicator())
                                else if (state is MedicineError)
                                  Text('Error: ${state.message}')
                                else if (state is MedicineLoaded)
                                  SizedBox(
                                    height: 260,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: state.medicines.map((medicine) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: MedicineWidget(medicine: medicine),
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
                      // Inventory content (placeholder)
                      const InventoryPage(),
                      // Orders content (placeholder)
                      const OrdersPage(),
                      // Settings content (placeholder)
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
                // No navigation logic needed; IndexedStack handles page switching
              },
            ),
          ),
        // QR Code Icon
          Positioned(
            left: 0,
            right: 0,
            bottom: 20, // Position above the bottom navigation bar
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
      ),
    );
  }
}