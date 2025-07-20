import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/domain/entities/medicine.dart';
import 'package:pharmacist_mobile/presentation/pages/medicine_detail_page.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';

class MedicineWidget extends StatelessWidget {
  final Medicine medicine;

  const MedicineWidget({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final variant =
        medicine.variants.isNotEmpty ? medicine.variants.first : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider<MedicineBloc>(
              create: (_) {
                final bloc = getIt<MedicineBloc>();
                bloc.add(GetMedicineDetailsEvent(medicine.id));
                return bloc;
              },
              child: MedicineDetailPage(medicineId: medicine.id),
            ),
          ),
        );
      },
      child: SizedBox(
        width: 140, // was 160
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  medicine.picture,
                  height: 90, // was 100
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 90,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              // Details
              Padding(
                padding: const EdgeInsets.all(8), // was 10
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${variant?.quantityAvailable ?? 0} ${variant?.unit ?? ''}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 7,
                              color: variant!.quantityAvailable > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              variant.quantityAvailable > 0
                                  ? 'In-stock'
                                  : 'Out',
                              style: TextStyle(
                                color: variant.quantityAvailable > 0
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${variant.pricePerUnit.toStringAsFixed(0)} ETB / ${variant.unit}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
