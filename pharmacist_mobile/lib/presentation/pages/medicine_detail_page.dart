import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';
import 'package:pharmacist_mobile/domain/entities/medicine_variant.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_state.dart';
import 'package:pharmacist_mobile/presentation/blocs/cart/cart_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';
import 'package:intl/intl.dart';
import 'package:pharmacist_mobile/presentation/blocs/cart/cart_event.dart';
import 'package:pharmacist_mobile/presentation/pages/edit_medicine_page.dart';

class MedicineDetailPage extends StatefulWidget {
  final String? medicineId;
  final Medicine? medicine; // Pass this if coming from scanner

  const MedicineDetailPage({
    super.key,
    this.medicineId,
    this.medicine,
  }) : assert(medicineId != null || medicine != null,
            "Either medicineId or medicine must be provided");

  @override
  _MedicineDetailPageState createState() => _MedicineDetailPageState();
}

class _MedicineDetailPageState extends State<MedicineDetailPage> {
  MedicineVariant? selectedVariant; // Changed to nullable
  int quantity = 1; // State variable to track the quantity

  @override
  void initState() {
    super.initState();
    final bloc = context.read<MedicineBloc>();
    if (widget.medicine != null) {
      bloc.add(AlreadyFetchedMedicineEvent(widget.medicine!));
    } else if (widget.medicineId != null) {
      bloc.add(GetMedicineDetailsEvent(widget.medicineId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (_) => getIt<CartBloc>(),
      child: Scaffold(
        body: BlocBuilder<MedicineBloc, MedicineState>(
          builder: (context, state) {
            if (state is MedicineLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MedicineDetailsLoaded) {
              var medicine = state.medicine;

              // Initialize the selected variant if not already set
              selectedVariant ??= medicine.variants.first;
              final id = widget.medicineId ?? widget.medicine!.id;

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        // Medicine image
                        Container(
                          width: double.infinity,
                          height: 250,
                          color: Colors.blue[50],
                          child: medicine.picture.isNotEmpty
                              ? Image.network(
                                  medicine.picture,
                                  height: 250,
                                  fit: BoxFit.cover,
                                )
                              : const Placeholder(
                                  fallbackHeight: 250,
                                  fallbackWidth: double.infinity,
                                ),
                        ),

                        // Card with medicine info
                        Container(
                          transform: Matrix4.translationValues(0, -20, 0),
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name + dosage selector
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    medicine.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                          255,
                                          238,
                                          238,
                                          238,
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedVariant?.unit,
                                      underline: const SizedBox(),
                                      items: medicine.variants
                                          .map(
                                            (variant) =>
                                                DropdownMenuItem<String>(
                                              value: variant.unit,
                                              child: Text(
                                                '${variant.unit}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedVariant =
                                              medicine.variants.firstWhere(
                                            (variant) => variant.unit == value,
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Stock, price, expiry
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      238,
                                      238,
                                      238,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    infoTile(
                                      'Stock Quantity',
                                      '${selectedVariant?.quantityAvailable ?? 0} units',
                                    ),
                                    infoTile(
                                      'Price',
                                      '${selectedVariant?.pricePerUnit ?? 0} Birr',
                                    ),
                                    infoTile(
                                      'Expiry Date',
                                      selectedVariant != null
                                          ? DateFormat('MMM dd, yyyy').format(
                                              selectedVariant!.expiryDate,
                                            )
                                          : 'N/A',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Description
                              if (medicine.description != null &&
                                  medicine.description!.isNotEmpty) ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                        255,
                                        238,
                                        238,
                                        238,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      sectionTitle('Description:'),
                                      const SizedBox(height: 8),
                                      sectionText(medicine.description!),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],

                              // Medical Usage
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      238,
                                      238,
                                      238,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sectionTitle('Medical Usage:'),
                                    const SizedBox(height: 8),
                                    sectionTextBullet([
                                      'Relieves headaches, muscle aches, and menstrual cramps.',
                                      'Reduces fever associated with infections or illnesses.',
                                      'Suitable for short-term pain management in adults and children over 12.',
                                      'Can be used as an adjunct in cold and flu symptom relief.',
                                    ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Back button overlay
                  Positioned(
                    top: 30,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // 🔹 Three-dot menu overlay (right)
                  Positioned(
                    top: 30,
                    right: 16,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthAuthenticated) {
                          final user = state.user;

                          if (user.role == 'owner' || user.role == 'admin') {
                            return PopupMenuButton<String>(
                              color: Colors.white,
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.more_vert,
                                    size: 20, color: Colors.white),
                              ),
                              onSelected: (value) async {
                                if (value == "edit") {
                                  final updatedMedicineId =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditMedicinePage(
                                        medicineId: id,
                                      ),
                                    ),
                                  );

                                  if (updatedMedicineId != null) {
                                    context.read<MedicineBloc>().add(
                                        GetMedicineDetailsEvent(
                                            updatedMedicineId));
                                  }
                                } else if (value == "delete") {
                                  Navigator.pop(context);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: "edit",
                                  child: Text("Edit"),
                                ),
                                PopupMenuItem(
                                  value: "delete",
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              );
            } else if (state is MedicineError) {
              final id = widget.medicineId ?? widget.medicine!.id;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MedicineBloc>().add(
                              GetMedicineDetailsEvent(id),
                            );
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text("No medicine selected."));
          },
        ),

        // Add to cart bar
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
          ),
          child: Row(
            children: [
              // Quantity adjust
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: const Color(0xFF01C587),
                    ),
                    const SizedBox(width: 5),
                    Text("$quantity", style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: const Color(0xFF01C587),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Add to Cart Button
              SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01C587),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {
                    if (selectedVariant != null) {
                      getIt<CartBloc>().add(
                        AddCartItemEvent(
                          medicineVariantId: selectedVariant!.id,
                          quantity: quantity,
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart')),
                      );
                    }
                  },
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoTile(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) => Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      );

  Widget sectionText(String text) => Text(
        text,
        style:
            const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
      );

  Widget sectionTextBullet(List<String> items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ", style: TextStyle(fontSize: 18)),
                    Expanded(
                      child: Text(item, style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      );
}
