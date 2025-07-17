import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';
import 'package:pharmacist_mobile/presentation/widgets/medicine_card.dart';
import 'package:pharmacist_mobile/presentation/widgets/custom_bottom_navigation_bar.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    context.read<MedicineBloc>().add(SearchMedicines(query));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _calculateCrossAxisCount(double screenWidth) {
    const double cardWidth = 180;
    return (screenWidth / cardWidth).floor().clamp(2, 4); // keep it between 2 and 4 cards per row
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MedicineBloc>()..add(const FetchAllMedicines()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          elevation: 0,
          toolbarHeight: 70,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.sort),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MedicineBloc, MedicineState>(
                builder: (context, state) {
                  if (state is MedicineLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MedicineError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is MedicineLoaded) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final crossAxisCount = _calculateCrossAxisCount(screenWidth);

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: state.medicines.length,
                      itemBuilder: (context, index) {
                        return MedicineWidget(medicine: state.medicines[index]);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            Positioned(
              bottom: 20,
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
          ],
        ),
      ),
    );
  }
}
