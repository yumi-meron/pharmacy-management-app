import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/domain/entities/medicine_variant.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';
import 'package:intl/intl.dart';

class MedicineDetailPage extends StatefulWidget {
  final String medicineId;

  const MedicineDetailPage({super.key, required this.medicineId});

  @override
  _MedicineDetailPageState createState() => _MedicineDetailPageState();
}

class _MedicineDetailPageState extends State<MedicineDetailPage> {
  MedicineVariant? selectedVariant; // Changed to nullable
  int quantity = 1; // State variable to track the quantity

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicineBloc>(
      create: (context) => getIt<MedicineBloc>()
        ..add(GetMedicineDetailsEvent(widget.medicineId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<MedicineBloc, MedicineState>(
          builder: (context, state) {
            if (state is MedicineLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MedicineDetailsLoaded) {
              final medicine = state.medicine;

              // Initialize the selected variant if not already set
              selectedVariant ??= medicine.variants.first;

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
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(24)),
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 238, 238, 238)),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedVariant?.unit,
                                      underline:
                                          const SizedBox(), // Remove default underline
                                      items: medicine.variants
                                          .map((variant) =>
                                              DropdownMenuItem<String>(
                                                value: variant.unit,
                                                child: Text('${variant.unit}',
                                                    style: const TextStyle(
                                                        fontSize: 12)),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedVariant = medicine.variants
                                              .firstWhere((variant) =>
                                                  variant.unit == value);
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
                                          255, 238, 238, 238)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    infoTile('Stock Quantity',
                                        '${selectedVariant?.quantityAvailable ?? 0} units'),
                                    infoTile('Price',
                                        '${selectedVariant?.pricePerUnit ?? 0} Birr'),
                                    infoTile(
                                      'Expiry Date',
                                      selectedVariant != null
                                          ? DateFormat('MMM dd, yyyy').format(
                                              selectedVariant!.expiryDate)
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
                                            255, 238, 238, 238)),
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
                                          255, 238, 238, 238)),
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
                    top: 10,
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
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is MedicineError) {
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
                        context
                            .read<MedicineBloc>()
                            .add(GetMedicineDetailsEvent(widget.medicineId));
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
                  color: Colors.grey[100], // Background color
                  borderRadius: BorderRadius.circular(50), // Border radius
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantity > 1)
                            quantity--; // Decrement but not below 1
                        });
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: const Color(0xFF01C587), // Updated color
                    ),
                    const SizedBox(width: 5), // Added space
                    Text("$quantity", style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 5), // Added space
                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++; // Increment
                        });
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: const Color(0xFF01C587), // Updated color
                    ),
                  ],
                ),
              ),
              const Spacer(), // Spacer to grow with screen width
              // Add to Cart Button
              SizedBox(
                width: 200,
                height: 35, // Fixed width of 50
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01C587), // Updated color
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontSize: 12, // Adjusted font size for smaller button
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
              fontWeight: FontWeight.bold, // Bold for the title
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.normal, // Thin for the content
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
            .map((item) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• ", style: TextStyle(fontSize: 18)),
                      Expanded(
                          child:
                              Text(item, style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                ))
            .toList(),
      );
}
