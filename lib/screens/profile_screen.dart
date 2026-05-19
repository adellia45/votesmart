import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String title;
  final dynamic kandidatId;
  final String nama;
  final String visi;
  final List<String> misi;
  final String kategori;
  final dynamic user;
  final bool canVote;

  const ProfileScreen({
    super.key,
    required this.title,
    this.kandidatId,
    this.nama = '',
    this.visi = '',
    this.misi = const [],
    this.kategori = '',
    this.user,
    this.canVote = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: const Color(0xFF0245A3), foregroundColor: Colors.white),
      body: Center(child: Text('Profil $nama - Akan dibuat lengkap')),
    );
  }
}