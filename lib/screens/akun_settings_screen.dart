import 'package:flutter/material.dart';
class AkunSettingsScreen extends StatelessWidget {
  const AkunSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Pengaturan Akun'), backgroundColor: const Color(0xFF0245A3), foregroundColor: Colors.white), body: const Center(child: Text('Halaman Pengaturan Akun')));
  }
}