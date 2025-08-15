import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/order_detail/order_detail_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/order_detail/order_detail_state.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/order_detail/order_detain_event.dart';
import 'package:pinput/pinput.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  const OrderDetailPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderDetailBloc>().add(LoadOrderDetailEvent(widget.orderId));
  }

  Widget _buildPatientCard(order) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Patient Detail",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Name: ${order.patient.fullName}"),
            Text("Phone: ${order.patient.phoneNumber}"),
            Text("Emergency Phone: ${order.patient.emergencyPhoneNumber}"),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineTable(order) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("List of Medicines",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Table(
              border: TableBorder.symmetric(
                  inside: const BorderSide(color: Colors.grey)),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
                  children: [
                    Padding(
                        padding: EdgeInsets.all(8), child: Text("Medicine")),
                    Padding(padding: EdgeInsets.all(8), child: Text("Unit")),
                    Padding(padding: EdgeInsets.all(8), child: Text("Qty")),
                    Padding(padding: EdgeInsets.all(8), child: Text("Price")),
                  ],
                ),
                ...order.items.map<TableRow>((item) {
                  return TableRow(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(item.medicineName)),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(item.unit)),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text("${item.quantity}")),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text("${item.pricePerUnit}")),
                    ],
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total: ${order.totalPrice} ETB",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Send OTP Verification",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // send OTP to patient then open confirmation sheet
                  showOtpConfirmationSheet(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.teal),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Patient Contact"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // send OTP to emergency contact then open confirmation sheet
                  showOtpConfirmationSheet(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.teal),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Emergency Contact"),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Cancel order
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Confirm order
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Confirm"),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Detail')),
      body: BlocBuilder<OrderDetailBloc, OrderDetailState>(
        builder: (context, state) {
          if (state is OrderDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailLoaded) {
            final order = state.detail;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPatientCard(order),
                  _buildMedicineTable(order),
                  const SizedBox(height: 16),
                  _buildOtpSection(),
                  const SizedBox(height: 16),
                  _buildActionButtons(),
                ],
              ),
            );
          } else if (state is OrderDetailError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

void showOtpConfirmationSheet(BuildContext context) {
  final otpController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

      return Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: bottomPadding + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "OTP Confirmation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // OTP Input (using pinput or manual)
            Pinput(
              length: 6,
              controller: otpController,
              defaultPinTheme: PinTheme(
                width: 50,
                height: 50,
                textStyle: const TextStyle(fontSize: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive it yet? "),
                GestureDetector(
                  onTap: () {
                    // resend OTP
                  },
                  child: const Text(
                    "Send OTP Again",
                    style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final otp = otpController.text.trim();
                      if (otp.length == 6) {
                        // TODO: verify OTP via bloc
                        // context.read<OrderDetailBloc>().add(VerifyOtpEvent(otp));
                        // Close the sheet after verification

                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Confirm"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
