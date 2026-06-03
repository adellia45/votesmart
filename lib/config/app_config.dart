import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0245A3);
  static const Color primaryDark = Color(0xFF01367A);
  static const Color primaryLight = Color(0xFF0355C4);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF141B34);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color pink = Color(0xFFEC4899);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}

class ApiConfig {
  // KARENA KAMU JALANKAN DI CHROME LAPTOP (MODE WEB), PAKAI LOCALHOST
  static const String baseUrl = 'http://localhost:8080/latihanvotesmartk4_api';
}