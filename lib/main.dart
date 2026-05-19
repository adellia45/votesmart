import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart'; // Tambahkan screens/
import 'screens/home_screen.dart';   // Tambahkan screens/

void main() {
  runApp(const VoteSmartApp());
}

class VoteSmartApp extends StatelessWidget {
  const VoteSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoteSmartK4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF0245A3),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const SplashScreenWrapper(),
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash ? const SplashScreen() : const HomeScreen();
  }
}