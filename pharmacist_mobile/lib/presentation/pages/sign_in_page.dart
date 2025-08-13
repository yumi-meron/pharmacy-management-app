import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_event.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_state.dart';
import 'package:pharmacist_mobile/presentation/pages/forgot_password_page.dart';
import 'package:pharmacist_mobile/presentation/pages/home_page.dart';
import 'package:pharmacist_mobile/presentation/widgets/custom_text_field.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 40,
                    ), // Initial top spacing (adjustable via theme)
                    Center(
                      child: Text(
                        'Sign in to your account',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ), // Spacing between title and fields
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Phone Number',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 7),
                        CustomTextField(
                          label: 'Enter your phone number',
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 7),

                        CustomTextField(
                          label: 'Enter your password',
                          controller: passwordController,
                          obscureText: true,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF01C587),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                  ), // Minimal top padding for button
                  child: state is AuthLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              SignInEvent(
                                phoneController.text,
                                passwordController.text,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              2,
                              11,
                              38,
                            ), // Very dark blue
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ), // Very rounded corners
                            ),
                            minimumSize: const Size(
                              double.infinity,
                              50,
                            ), // Full width, fixed height
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
