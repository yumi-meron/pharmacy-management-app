import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
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
                // TODO: Dispatch update medicine event with new values
                // Example: context.read<MedicineBloc>().add(UpdateMedicineEvent(...));
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

            // Prefill controllers (only if empty, so they don’t keep resetting on rebuilds)
            if (_stockController.text.isEmpty) {
              _stockController.text = selectedVariant.quantityAvailable.toString() ;
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
                    // Medicine Picture
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // TODO: implement image picker
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: medicine.picture != null
                              ? NetworkImage(medicine.picture!)
                              : null,
                          child: medicine.picture == null
                              ? const Icon(Icons.add_a_photo, size: 40)
                              : null,
                        ),
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
                      validator: (value) =>
                          value!.isEmpty ? "Enter price" : null,
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
