import 'package:flutter/material.dart';

class Calon {
  String nama;
  String kelas;
  String alamat;
  String email;
  String visi;
  String misi;
  String pengalaman;
  String? fotoPath;
  String fotoUrl;
  Color avatarColor;

  Calon({
    required this.nama,
    required this.kelas,
    this.alamat = '',
    this.email = '',
    required this.visi,
    this.misi = '',
    this.pengalaman = '',
    this.fotoPath,
    this.fotoUrl = '',
    this.avatarColor = const Color(0xFF3B82F6),
  });
}

List<Calon> listKetos = [
  Calon(nama: 'Seonghyeon', kelas: 'XII IPA 1', visi: 'Meningkatkan Disiplin', misi: '1. Membangun tata tertib\n2. Menegakkan aturan', fotoUrl: 'https://i.pravatar.cc/150?img=11', avatarColor: const Color(0xFF3B82F6)),
  Calon(nama: 'A - na', kelas: 'XII IPA 2', visi: 'Meningkatkan Kebersihan', misi: '1. Program kerja bersih\n2. Menjaga lingkungan', fotoUrl: 'https://i.pravatar.cc/150?img=45', avatarColor: const Color(0xFFEF4444)),
  Calon(nama: 'Yuha', kelas: 'XII IPS 1', visi: 'Meningkatkan Kreativitas', misi: '1. Membuat wadah kreatif\n2. Mendorong inovasi', fotoUrl: 'https://i.pravatar.cc/150?img=44', avatarColor: const Color(0xFFF59E0B)),
  Calon(nama: 'James', kelas: 'XII IPS 2', visi: 'Meningkatkan Keimanan', misi: '1. Meningkatkan ibadah\n2. Memperkuat silaturahmi', fotoUrl: 'https://i.pravatar.cc/150?img=12', avatarColor: const Color(0xFF10B981)),
];

List<Calon> listKetum = [
  Calon(nama: 'Keonho', kelas: 'XII IPA 1', visi: 'Meningkatkan Keimanan', misi: '1. Meningkatkan ibadah\n2. Memperkuat silaturahmi', fotoUrl: 'https://i.pravatar.cc/150?img=13', avatarColor: const Color(0xFF8B5CF6)),
  Calon(nama: 'Juun', kelas: 'XII IPA 2', visi: 'Meningkatkan Kreativitas', misi: '1. Membuat wadah kreatif\n2. Mendorong inovasi', fotoUrl: 'https://i.pravatar.cc/150?img=14', avatarColor: const Color(0xFFEC4899)),
  Calon(nama: 'Juhoon', kelas: 'XII IPS 1', visi: 'Meningkatkan Disiplin', misi: '1. Membangun tata tertib\n2. Menegakkan aturan', fotoUrl: 'https://i.pravatar.cc/150?img=15', avatarColor: const Color(0xFF06B6D4)),
  Calon(nama: 'Carmen', kelas: 'XII IPS 2', visi: 'Meningkatkan Kebersihan', misi: '1. Program kerja bersih\n2. Menjaga lingkungan', fotoUrl: 'https://i.pravatar.cc/150?img=16', avatarColor: const Color(0xFFF97316)),
];