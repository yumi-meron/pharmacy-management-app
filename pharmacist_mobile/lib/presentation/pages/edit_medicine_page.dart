import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';

class EditMedicinePage extends StatefulWidget {
  final String medicineId;
  const EditMedicinePage({Key? key, required this.medicineId})
      : super(key: key);

  @override
  State<EditMedicinePage> createState() => _EditMedicinePageState();
}

class _EditMedicinePageState extends State<EditMedicinePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for editable fields
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _expireDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _usageController = TextEditingController();
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();

  File? _pickedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MedicineBloc, MedicineState>(
        builder: (context, state) {
          if (state is MedicineLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MedicineDetailsLoaded) {
            final medicine = state.medicine;
            final selectedVariant = medicine.variants.firstWhere(
              (variant) => variant.id == widget.medicineId,
              orElse: () => medicine.variants.first,
            );

            // Prefill controllers only once
            if (_stockController.text.isEmpty) {
              _stockController.text =
                  selectedVariant.quantityAvailable.toString();
            }
            if (_priceController.text.isEmpty) {
              _priceController.text = selectedVariant.pricePerUnit.toString();
            }
            if (_expireDateController.text.isEmpty) {
              final expiryDate =
                  DateTime.parse(selectedVariant.expiryDate.toString());
              _expireDateController.text =
                  "${expiryDate.year}-${expiryDate.month.toString().padLeft(2, '0')}-${expiryDate.day.toString().padLeft(2, '0')}";
            }
            if (_descriptionController.text.isEmpty) {
              _descriptionController.text = medicine.description ?? "";
            }
            if (_medicineNameController.text.isEmpty) {
              _medicineNameController.text = medicine.name;
            }
            if (_brandController.text.isEmpty) {
              _brandController.text = selectedVariant.brand;
            }

            return Stack(
              children: [
                // Main content with scrollable form
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Image Section with Edit Picture functionality
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 250,
                            color: Colors.blue[50],
                            child: _pickedImage != null
                                ? Image.file(
                                    _pickedImage!,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  )
                                : (medicine.picture != null &&
                                        medicine.picture!.isNotEmpty)
                                    ? Image.network(
                                        medicine.picture!,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      )
                                    : const Placeholder(
                                        fallbackHeight: 250,
                                        fallbackWidth: double.infinity,
                                      ),
                          ),
                          Positioned(
                            top: 10,
                            right: 16,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Form Section
                      Container(
                        transform: Matrix4.translationValues(0, -20, 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 40),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Medicine Name Field

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Medicine Name",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 35,
                                    child: TextFormField(
                                      controller: _medicineNameController,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 10),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 228, 228, 228)),
                                        ),
                                      ),
                                      style: const TextStyle(fontSize: 14),
                                      validator: (value) => value!.isEmpty
                                          ? "Enter medicine name"
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Stock Quantity and Price per Unit
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Stock Quantity",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 35,
                                          child: TextFormField(
                                            controller: _stockController,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 228, 228, 228)),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            validator: (value) => value!.isEmpty
                                                ? "Enter stock quantity"
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Price per Unit",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 35,
                                          child: TextFormField(
                                            controller: _priceController,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 228, 228, 228)),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            validator: (value) => value!.isEmpty
                                                ? "Enter price"
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Expire Date and Brand Name
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Expire Date",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 35,
                                          child: TextFormField(
                                            controller: _expireDateController,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 228, 228, 228)),
                                              ),
                                            ),
                                            onTap: () async {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final picked =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2024),
                                                lastDate: DateTime(2100),
                                              );
                                              if (picked != null) {
                                                // Format the date to exclude the time
                                                _expireDateController.text =
                                                    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                              }
                                            },
                                            style:
                                                const TextStyle(fontSize: 14),
                                            validator: (value) => value!.isEmpty
                                                ? "Enter expire date"
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Brand Name",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 35,
                                          child: TextFormField(
                                            controller: _brandController,
                                            textAlign: TextAlign.left,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 228, 228, 228)),
                                              ),
                                            ),
                                            style:
                                                const TextStyle(fontSize: 14),
                                            readOnly: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Description
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Description",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _descriptionController,
                                    textAlign: TextAlign.left,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 228, 228, 228)),
                                      ),
                                    ),
                                    maxLines: 3,
                                    style: const TextStyle(fontSize: 14),
                                    validator: (value) => value!.isEmpty
                                        ? "Enter description"
                                        : null,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Medical Usage
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     const Text(
                              //       "Medical Usage",
                              //       style: TextStyle(
                              //           fontSize: 14,
                              //           fontWeight: FontWeight.w600),
                              //     ),
                              //     const SizedBox(height: 8),
                              //     TextFormField(
                              //       controller: _usageController,
                              //       textAlign: TextAlign.left,
                              //       decoration: InputDecoration(
                              //         contentPadding:
                              //             const EdgeInsets.symmetric(
                              //                 vertical: 8, horizontal: 10),
                              //         border: OutlineInputBorder(
                              //           borderRadius: BorderRadius.circular(10),
                              //           borderSide: const BorderSide(
                              //               color: Color.fromARGB(
                              //                   255, 228, 228, 228)),
                              //         ),
                              //       ),
                              //       maxLines: 3,
                              //       style: const TextStyle(fontSize: 14),
                              //       validator: (value) => value!.isEmpty
                              //           ? "Enter medical usage"
                              //           : null,
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(
                                  height:
                                      1000), // Extra padding to avoid overlap with buttons
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Fixed Buttons at Bottom
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 220, 220, 220)
                              .withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cancel Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                                context); // Close the page without saving
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Save Button
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Dispatch the save event (extend to include _pickedImage path/upload later)
                              // context.read<MedicineBloc>().add(UpdateMedicineEvent(
                              //   id: widget.medicineId,
                              //   stock: int.parse(_stockController.text),
                              //   price: double.parse(_priceController.text),
                              //   expiryDate: _expireDateController.text,
                              //   description: _descriptionController.text,
                              //   usage: _usageController.text,
                              //   pictureFile: _pickedImage,
                              // ));
                              // Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is MedicineError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
