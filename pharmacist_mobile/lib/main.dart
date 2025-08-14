import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/auth/auth_bloc.dart';
import 'package:pharmacist_mobile/presentation/blocs/orders/orders_bloc.dart';
import 'package:pharmacist_mobile/presentation/pages/sign_in_page.dart';
import 'package:pharmacist_mobile/core/di/injection.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await setup(); // Initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<OrdersBloc>()),
      ],
      child: MaterialApp(
        title: 'Pharmacy App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF01C587),
            primary: const Color(0xFF01C587),
            secondary: const Color(0xFF26D191),
            surface: Colors.white,
            background: const Color(0xFFF5F5F5),
            error: Colors.redAccent,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.black87,
            onBackground: Colors.black87,
            onError: Colors.white,
            brightness: Brightness.light,
          ),
          textTheme: ThemeData.light().textTheme
              .apply(fontFamily: 'Poppins')
              .copyWith(
                bodyLarge: const TextStyle(fontWeight: FontWeight.w500),
                bodyMedium: const TextStyle(fontWeight: FontWeight.w500),
                headlineLarge: const TextStyle(fontWeight: FontWeight.w500),
                headlineMedium: const TextStyle(fontWeight: FontWeight.w500),
                headlineSmall: const TextStyle(fontWeight: FontWeight.w500),
                titleLarge: const TextStyle(fontWeight: FontWeight.w500),
                titleMedium: const TextStyle(fontWeight: FontWeight.w500),
                titleSmall: const TextStyle(fontWeight: FontWeight.w500),
              ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF01C587),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF01C587)),
            ),
            labelStyle: TextStyle(color: Color(0xFF01C587)),
          ),
          useMaterial3: true,
        ),
        home: const SignInPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
