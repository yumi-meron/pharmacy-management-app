import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/medicine/medicine_state.dart';
import 'package:pharmacist_mobile/presentation/pages/medicine_detail_page.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _barcodeCaptured = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Medicine")),
      body: BlocConsumer<MedicineBloc, MedicineState>(
        listener: (context, state) {
          if (state is MedicineDetailsLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("✅ Found: ${state.medicine.name}")),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MedicineDetailPage(medicine: state.medicine),
              ),
            );
          } else if (state is MedicineError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("❌ ${state.message}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Camera feed
              MobileScanner(
                onDetect: (capture) {
                  if (_barcodeCaptured) return; // avoid duplicate scans
                  final barcode = capture.barcodes.first.rawValue;
                  if (barcode != null) {
                    setState(() => _barcodeCaptured = true);
                    context
                        .read<MedicineBloc>()
                        .add(ScanBarcodeEvent(barcode));
                    // reset after 2 seconds to allow re-scanning if needed
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) setState(() => _barcodeCaptured = false);
                    });
                  }
                },
              ),

              // Custom overlay (like in your picture)
              Center(
                child: Container(
                  width: 250,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _barcodeCaptured ? Colors.green : Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Loader
              if (state is MedicineLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
