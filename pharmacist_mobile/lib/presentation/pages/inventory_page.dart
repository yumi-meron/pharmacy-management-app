import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';
import 'package:pharmacist_mobile/presentation/pages/cart_page.dart';
import 'package:pharmacist_mobile/presentation/widgets/medicine_card.dart';

class InventoryPage extends StatefulWidget {
  final String? initialCategory;
  final String? initialType;

  const InventoryPage({super.key, this.initialCategory, this.initialType});

  @override
  State<InventoryPage> createState() => InventoryPageState();
}

class InventoryPageState extends State<InventoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedType;
  String? _selectedCategory;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _selectedType = widget.initialType ?? "name";
    _selectedCategory = widget.initialCategory;

    _searchController.addListener(_onSearchChanged);

    _fetchMedicines();
  }

  void _fetchMedicines() {
    if (_selectedCategory != null || _searchController.text.isNotEmpty) {
      context.read<MedicineBloc>().add(
            SearchMedicines(
              _searchController.text,
              filter: _selectedType,
              category: _selectedCategory,
            ),
          );
    } else {
      context.read<MedicineBloc>().add(const FetchAllMedicines());
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      _fetchMedicines();
    });
  }

  // 🔹 Allow category updates dynamically from HomePage
  void setCategory(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _fetchMedicines();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  int _calculateCrossAxisCount(double screenWidth) {
    const double cardWidth = 180;
    return (screenWidth / cardWidth).floor().clamp(2, 4);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Search bar (no AppBar, so nav bar stays visible)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.filter_list),
                      onSelected: (value) {
                        if (["name", "description", "brand"].contains(value)) {
                          setState(() => _selectedType = value);
                        } else if ([
                          "antibiotics",
                          "vitamins",
                          "pain relief",
                          "cold & flu"
                        ].contains(value)) {
                          setState(() => _selectedCategory = value);
                        } else if (value == "reset_category") {
                          setState(() => _selectedCategory = null);
                        }
                        _onSearchChanged();
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          enabled: false,
                          child: Text(
                            "Search by",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...["name", "description", "brand"].map(
                          (e) => CheckedPopupMenuItem<String>(
                            value: e,
                            checked: _selectedType == e,
                            child: Text(e),
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                          enabled: false,
                          child: Text(
                            "Category",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...[
                          "antibiotics",
                          "vitamins",
                          "pain relief",
                          "cold & flu"
                        ].map(
                          (e) => CheckedPopupMenuItem<String>(
                            value: e,
                            checked: _selectedCategory == e,
                            child: Text(e),
                          ),
                        ),
                        if (_selectedCategory != null)
                          const PopupMenuItem<String>(
                            value: "reset_category",
                            child: Text(
                              "Clear category",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
              ),
            ],
          ),
        ),

        // 🔹 Main content
        Expanded(
          child: BlocBuilder<MedicineBloc, MedicineState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<MedicineBloc>().add(const FetchAllMedicines());
                },
                child: () {
                  if (state is MedicineLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MedicineError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is MedicineLoaded) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final crossAxisCount =
                        _calculateCrossAxisCount(screenWidth);

                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                    return const Center(child: Text('No data'));
                  }
                }(),
              );
            },
          ),
        ),
      ],
    );
  }
}
