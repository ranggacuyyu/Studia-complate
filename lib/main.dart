import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudiaApp());
}

class StudiaApp extends StatelessWidget {
  const StudiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studia Complate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        primaryColor: const Color(0xFF1E3A34),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A34),
          primary: const Color(0xFF1E3A34),
          secondary: const Color(0xFF52B788),
          error: const Color(0xFFE76F51),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

