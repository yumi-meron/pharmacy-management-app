import 'package:flutter/material.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';

class MedicineWidget extends StatelessWidget {
  final Medicine medicine;

  const MedicineWidget({required this.medicine});

  @override
  Widget build(BuildContext context) {
    final variant = medicine.variants.isNotEmpty ? medicine.variants.first : null;
    return Card(
      child: ListTile(
        leading: Image.network(medicine.picture, width: 50, height: 50, fit: BoxFit.cover),
        title: Text('${variant?.brand ?? ''} ${medicine.name}'),
        subtitle: Text(
          '${variant!.quantityAvailable > 0 ? 'in-stock' : 'out-of-stock'} • ${variant.pricePerUnit} ETB',
        ),
      ),
    );
  }
}