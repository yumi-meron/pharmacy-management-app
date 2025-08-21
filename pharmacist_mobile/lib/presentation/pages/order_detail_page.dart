import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/domain/entities/order_detail.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/order_detail/order_detail_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/order_detail/order_detail_state.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/order_detail/order_detain_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/otp_verify/otp_verify_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/otp_verify/otp_verify_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/otp_verify/otp_verify_state.dart';
import 'package:pinput/pinput.dart';


class OrderDetailPage extends StatefulWidget {
  final String orderId;
  const OrderDetailPage({Key? key, required this.orderId}) : super(key: key);
  

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _isPatientSelected = true;
  @override
  void initState() {
    super.initState();
    context.read<OrderDetailBloc>().add(LoadOrderDetailEvent(widget.orderId));
    // context.read<OtpVerifyBloc>().add(OtpVerifyInitialEvent());
  }

  Widget _buildPatientCard(order) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Patient Detail",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text("Name: ${order.patient.fullName}"),
            const SizedBox(height: 8),
            Text("Phone: ${order.patient.phoneNumber}"),
            const SizedBox(height: 8),
            Text("Emergency Phone: ${order.patient.emergencyPhoneNumber}"),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineTable(order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text("List of Medicines",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Column(
              children: order.items.map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text(item.medicineName,
                              style: const TextStyle(fontSize: 12))),
                      Expanded(
                          child: Text(item.unit,
                              style: const TextStyle(fontSize: 12))),
                      Expanded(
                          child: Text("${item.quantity}",
                              style: const TextStyle(fontSize: 12))),
                      Expanded(
                          child: Text("${item.pricePerUnit}",
                              style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total:              ${order.totalPrice} ETB",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpSection(order) {
    // bool isPatientSelected = true; // Default selection

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Send OTP Verification",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPatientSelected = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              _isPatientSelected ? Colors.green : Colors.white,
                          border: Border.all(
                            color: _isPatientSelected
                                ? Colors.green
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Column(
                          children: [
                            Text(
                              "Patient Contact",
                              style: TextStyle(
                                color: _isPatientSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              order.patient.phoneNumber,
                              style: TextStyle(
                                color: _isPatientSelected
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPatientSelected = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              !_isPatientSelected ? Colors.green : Colors.white,
                          border: Border.all(
                            color: !_isPatientSelected
                                ? Colors.green
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Column(
                          children: [
                            Text(
                              "Emergency Contact",
                              style: TextStyle(
                                color: !_isPatientSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              order.patient.emergencyPhoneNumber,
                              style: TextStyle(
                                color: !_isPatientSelected
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildActionButtons(order) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // Cancel order
              },
              icon: const Icon(Icons.close, color: Colors.red),
              label: const Text("Discard"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                side: BorderSide.none, // Removed the border line
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                final phoneNumber = _isPatientSelected
                  ? order.patient.phoneNumber
                  : order.patient.emergencyPhoneNumber;
                // Request OTP for order confirmation
                context.read<OtpVerifyBloc>().add(
                  RequestOrderOtpEvent(
                    id: order.id,
                    phoneNumber: phoneNumber,
                  ),
                );

                // Confirm order
                showOtpConfirmationSheet(context, order);
                
              },
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text("Confirm"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Detail',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<OrderDetailBloc, OrderDetailState>(
        builder: (context, state) {
          if (state is OrderDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailLoaded) {
            final order = state.detail;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPatientCard(order),
                        _buildMedicineTable(order),
                        const SizedBox(height: 16),
                        _buildOtpSection(order),
                      ],
                    ),
                  ),
                ),
                _buildActionButtons(order), // Buttons at the bottom
              ],
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
void showOtpConfirmationSheet(BuildContext parentContext, OrderDetail order) {
  final otpController = TextEditingController();

  showModalBottomSheet(
    context: parentContext,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return BlocProvider.value(
        value: BlocProvider.of<OtpVerifyBloc>(parentContext),
        child: BlocBuilder<OtpVerifyBloc, OtpVerifyState>(
          builder: (context, state) {
            final bottomPadding = MediaQuery.of(sheetContext).viewInsets.bottom;

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
                          style: TextStyle(
                              color: Colors.teal, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: state is OtpVerifyLoading
                              ? null
                              : () {
                                  final otp = otpController.text.trim();
                                  if (otp.length == 6) {
                                    context.read<OtpVerifyBloc>().add(
                                          VerifyOrderOtpEvent(
                                            id: order.id,
                                            otp: otp,
                                          ),
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal),
                          child: state is OtpVerifyLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text("Confirm"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
