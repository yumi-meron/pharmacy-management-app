import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacist_mobile/domain/entities/update_medicine.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
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

  // Controllers
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
          }
          if (state is MedicineUpdating) {
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

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120), // space for buttons
                child: Column(
                  children: [
                    // Image Section
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
                          top: 20,
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
                            _buildTextField(
                              label: "Medicine Name",
                              controller: _medicineNameController,
                              validator: "Enter medicine name",
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    label: "Stock Quantity",
                                    controller: _stockController,
                                    keyboardType: TextInputType.number,
                                    validator: "Enter stock quantity",
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    label: "Price per Unit",
                                    controller: _priceController,
                                    keyboardType: TextInputType.number,
                                    validator: "Enter price",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDateField(
                                    label: "Expire Date",
                                    controller: _expireDateController,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    label: "Brand Name",
                                    controller: _brandController,
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              label: "Description",
                              controller: _descriptionController,
                              validator: "Enter description",
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is MedicineError) {
            return Center(
                child: Text("Error: ${(state as MedicineError).message}"));
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color:
                  const Color.fromARGB(255, 220, 220, 220).withOpacity(0.2),
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
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
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
                  final state =
                      context.read<MedicineBloc>().state as MedicineDetailsLoaded;
                  final medicine = state.medicine;
                  final selectedVariant = medicine.variants.firstWhere(
                    (variant) => variant.id == widget.medicineId,
                    orElse: () => medicine.variants.first,
                  );

                  UpdateMedicine newMedicine = UpdateMedicine(
                    id: widget.medicineId,
                    variantid: selectedVariant.id,
                    name: _medicineNameController.text,
                    description: _descriptionController.text,
                    barcode: selectedVariant.barcode ?? "",
                    unit: selectedVariant.unit ?? "",
                    brand: _brandController.text,
                    price: double.parse(_priceController.text),
                    quantityAvailable: int.parse(_stockController.text),
                    imageUrl: _pickedImage != null
                        ? _pickedImage!.path
                        : (medicine.picture ?? ""),
                    expiryDate: _expireDateController.text,
                  );
                  context
                      .read<MedicineBloc>()
                      .add(UpdateMedicineEvent(medicine: newMedicine));
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
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
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? validator,
    TextInputType? keyboardType,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 228, 228, 228)),
            ),
          ),
          validator: (value) =>
              validator != null && value!.isEmpty ? validator : null,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2024),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              controller.text =
                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
            }
          },
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 228, 228, 228)),
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
