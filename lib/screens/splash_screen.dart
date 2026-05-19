import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF01367A), // biru lebih gelap (atas)
              Color(0xFF0245A3), // warna utama (tengah)
              Color(0xFF0355C4), // biru lebih terang (bawah)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo SMK Negeri 4
            Image.asset(
              'assets/images/logo_smk4.png',
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 60,
                    color: Colors.white,
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Judul utama
            Text(
              'VoteSmartK4',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Pilketos & Pilketum',
              style: GoogleFonts.inter(
                color: const Color(0xFF90CAF9),
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 8),

            // Tagline
            Text(
              'Digital',
              style: GoogleFonts.inter(
                color: const Color(0xFF64B5F6),
                fontSize: 16,
                fontWeight: FontWeight.w300,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}