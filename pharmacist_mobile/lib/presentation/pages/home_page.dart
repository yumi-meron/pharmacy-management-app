import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';
import 'package:pharmacist_mobile/domain/usecases/medicine/get_all_medicine.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_state.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';
import 'package:pharmacist_mobile/presentation/pages/cart_page.dart';
import 'package:pharmacist_mobile/presentation/pages/inventory_page.dart';
import 'package:pharmacist_mobile/presentation/pages/orders_list_page.dart';
import 'package:pharmacist_mobile/presentation/pages/settings_page.dart';
import 'package:pharmacist_mobile/presentation/widgets/medicine_card.dart';
import 'package:pharmacist_mobile/presentation/widgets/custom_bottom_navigation_bar.dart';

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
      appBar: _selectedIndex == 0
          ? AppBar(
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
                            const Text(
                              'Hi, Welcome Back',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.teal,
                              ),
                            ),
                            Text(
                              user.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return const Text("Love Care Pharmacy");
                  }
                },
              ),
            )
          : null, // Hide AppBar on other pages
      body: Stack(
        children: [
          SafeArea(
            child: BlocProvider(
              create: (context) => MedicineBloc(
                getIt(),
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search medicines...',
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 16,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(
                                              0xFFD3D3D3,
                                            ), // Light grey border
                                            width: 1.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(
                                              0xFFD3D3D3,
                                            ), // Light grey border
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors
                                                .teal, // Teal border when focused
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      onChanged: (query) => context
                                          .read<MedicineBloc>()
                                          .add(SearchMedicines(query)),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    height: 120,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Background Image
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                'assets/images/pharmacy_background.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        // Gradient Overlay
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            gradient: const LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(
                                                  0xFF004D40,
                                                ), // Solid color on the left
                                                Colors.teal,
                                                Color(
                                                  0x30000000,
                                                ), // Fully transparent on the right
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Content
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 16.0,
                                            ), // Add margin to the left
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
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
                                        children:
                                            [
                                                  'Antibiotics',
                                                  'Vitamins',
                                                  'Pain Relief',
                                                  'Cold & Flu',
                                                ]
                                                .map(
                                                  (cat) => Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6.0,
                                                        ),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        foregroundColor:
                                                            Colors.black,
                                                        elevation:
                                                            0, // Remove shadow
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                80,
                                                              ),
                                                          side: const BorderSide(
                                                            color: Color(
                                                              0xFFD3D3D3,
                                                            ), // Light grey border
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {},
                                                      child: Text(
                                                        cat,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .w500, // Set text weight to w300
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  const Text(
                                    'Recent purchases',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (state is MedicineLoading)
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  else if (state is MedicineError)
                                    Text('Error: ${state.message}')
                                  else if (state is MedicineLoaded)
                                    SizedBox(
                                      height: 260,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: state.medicines.map((
                                            medicine,
                                          ) {
                                            return MedicineWidget(
                                              medicine: medicine,
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
                      const OrdersListPage(),
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
      ),
    );
  }
}
