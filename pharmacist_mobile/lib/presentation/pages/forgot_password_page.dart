import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_state.dart';
import 'package:pharmacist_mobile/presentation/widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  void _showOtpSheet(BuildContext context, String phone, String newPassword) {
    final otpController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: BlocProvider.of<AuthBloc>(context),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final bottomPadding =
                  MediaQuery.of(sheetContext).viewInsets.bottom;

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
                      "Enter OTP",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 50),
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
                        const Text("Didn't receive OTP? "),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<AuthBloc>()
                                .add(ForgotPasswordEvent(phone, newPassword));
                          },
                          child: const Text(
                            "Resend",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 36, // Set fixed height
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(sheetContext),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    EdgeInsets.zero, // Remove extra padding
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 36, // Set fixed height
                            child: ElevatedButton(
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      final otp = otpController.text.trim();
                                      if (otp.length == 6) {
                                        context
                                            .read<AuthBloc>()
                                            .add(VerifyOtpEvent(phone, otp));
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    EdgeInsets.zero, // Remove extra padding
                              ),
                              child: state is AuthLoading
                                  ? const SizedBox(
                                      height: 14,
                                      width: 14,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text(
                                      "Confirm",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Forgot Password        ',
            style: TextStyle(
              fontSize: 16, // smaller font size
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthOtpRequested) {
              _showOtpSheet(context, phoneController.text.trim(),
                  newPasswordController.text);
            } else if (state is AuthOtpVerified) {
              // clear controllers
              phoneController.clear();
              newPasswordController.clear();
              confirmPasswordController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('OTP Verified! Your password has been reset.')),
              );
              // close the forgot password page if you want:
              Navigator.pop(context);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phone Number',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          hintText: 'e.g. 0912345678',
                          hintStyle: TextStyle(
                              fontSize: 13, color: Colors.grey.shade400),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                        ),
                        style: const TextStyle(fontSize: 13),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Enter your phone number';
                          if (!RegExp(r'^(?:\d{10}|\+251\d{9})$').hasMatch(v))
                            return 'Enter a valid phone number (10 digits or +251XXXXXXXXX)';
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New Password',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          hintText: 'Enter new password',
                          hintStyle: TextStyle(
                              fontSize: 13, color: Colors.grey.shade400),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                        ),
                        style: const TextStyle(fontSize: 13),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Enter new password';
                          if (v.length < 6)
                            return 'Password must be at least 6 chars';
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Confirm New Password',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          hintText: 'Re-enter new password',
                          hintStyle: TextStyle(
                              fontSize: 13, color: Colors.grey.shade400),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                        ),
                        style: const TextStyle(fontSize: 13),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Confirm your password';
                          if (v != newPasswordController.text)
                            return 'Passwords do not match';
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: state is AuthLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 36, // Set the button height here
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    final phone = phoneController.text.trim();
                                    final newPassword =
                                        newPasswordController.text;
                                    context.read<AuthBloc>().add(
                                        ForgotPasswordEvent(
                                            phone, newPassword));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 2, 11, 38),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30.0), // Radius 30
                                  ),
                                  padding:
                                      EdgeInsets.zero, // Remove extra padding
                                  minimumSize: const Size(
                                      double.infinity, 36), // Height 36
                                ),
                                child: const Text(
                                  'Request OTP',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
