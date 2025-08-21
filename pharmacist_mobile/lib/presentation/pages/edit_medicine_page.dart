import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';

class EditMedicinePage extends StatefulWidget {
  final String medicineId;
  const EditMedicinePage({Key? key, required this.medicineId}) : super(key: key);

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

  File? _pickedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Medicine"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Example of dispatch (extend to include _pickedImage path/upload later)
                // context.read<MedicineBloc>().add(UpdateMedicineEvent(
                //   id: widget.medicineId,
                //   stock: int.parse(_stockController.text),
                //   price: double.parse(_priceController.text),
                //   expiryDate: _expireDateController.text,
                //   description: _descriptionController.text,
                //   usage: _usageController.text,
                //   pictureFile: _pickedImage, // handle uploading in bloc
                // ));
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
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
              _stockController.text = selectedVariant.quantityAvailable.toString();
            }
            if (_priceController.text.isEmpty) {
              _priceController.text = selectedVariant.pricePerUnit.toString();
            }
            if (_expireDateController.text.isEmpty) {
              _expireDateController.text = selectedVariant.expiryDate.toString();
            }
            if (_descriptionController.text.isEmpty) {
              _descriptionController.text = medicine.description ?? "";
            }
            // if (_usageController.text.isEmpty) {
            //   _usageController.text = medicine.medicalUsage ?? "";
            // }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Editable Medicine Picture (rectangular with overlay icon)
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 250,
                            color: Colors.blue[50],
                            child: _pickedImage != null
                                ? Image.file(
                                    _pickedImage!,
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  )
                                : (medicine.picture != null && medicine.picture!.isNotEmpty)
                                    ? Image.network(
                                        medicine.picture!,
                                        width: double.infinity,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      )
                                    : const Placeholder(
                                        fallbackHeight: 250,
                                        fallbackWidth: double.infinity,
                                      ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Stock Quantity
                    TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(
                        labelText: "Stock Quantity",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? "Enter stock quantity" : null,
                    ),
                    const SizedBox(height: 12),

                    // Price
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: "Price per unit",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? "Enter price" : null,
                    ),
                    const SizedBox(height: 12),

                    // Expire Date
                    TextFormField(
                      controller: _expireDateController,
                      decoration: const InputDecoration(
                        labelText: "Expire Date",
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          _expireDateController.text =
                              picked.toIso8601String().split("T").first;
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),

                    // Medical Usage
                    TextFormField(
                      controller: _usageController,
                      decoration: const InputDecoration(
                        labelText: "Medical Usage",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
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
