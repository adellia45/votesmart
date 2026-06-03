import 'dart:convert';
import 'dart:typed_data'; // Ditambahkan untuk penanganan bytes di Web
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

import '../config/app_config.dart';
import '../models/models.dart';

class ApiService {
  // ==================== AUTH ====================
  
  static Future<UserModel?> loginPemilih(
    String username,
    String nisNuptk,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'nis_nuptk': nisNuptk,
        }),
      );

      print("LOGIN RESPONSE:");
      print(response.body);

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        print("USER DATA:");
        print(data['data']);

        return UserModel.fromJson(data['data']);
      }

      return null;
    } catch (e) {
      print("LOGIN ERROR:");
      print(e);
      return null;
    }
  }

  static Future<AdminModel?> loginAdmin(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login_admin.php'),
        body: jsonEncode({'username': username, 'password': password}),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return AdminModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== KANDIDAT (USER) ====================
  
  static Future<List<KandidatModel>> getKandidat(String kategori) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/get_kandidat.php?kategori=$kategori'),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        List<dynamic> rawData = data['data'];
        return rawData.map((e) => KandidatModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<KandidatModel?> getDetailKandidat(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/get_kandidat.php?kategori=pilketos'),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        List<dynamic> rawData = data['data'];
        for (var item in rawData) {
          if (item['id'] == id) {
            return KandidatModel.fromJson(item);
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== VOTING ====================
  
  static Future<bool> submitVote(int userId, int kandidatId, String kategori) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/vote.php'),
        body: jsonEncode({
          'user_id': userId,
          'kandidat_id': kandidatId,
          'kategori': kategori,
        }),
      );
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  static Future<VoteStatusModel?> checkVoteStatus(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/check_vote.php?user_id=$userId'),
      );

      print("=== CHECK VOTE RESPONSE ===");
      print(response.body);

      final data = jsonDecode(response.body);

      print("=== DATA ===");
      print(data);

      if (data['success'] == true) {
        return VoteStatusModel.fromJson(data['data']);
      }

      return null;
    } catch (e) {
      print("CHECK VOTE ERROR:");
      print(e);
      return null;
    }
  }

  // ==================== HASIL VOTING ====================
  
  static Future<HasilVotingModel?> getHasilVoting(String kategori) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/get_result.php?kategori=$kategori'),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return HasilVotingModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== PEMILIH (ADMIN) ====================
  
  static Future<List<PemilihModel>> getPemilih({String? search}) async {
    try {
      String url = '${ApiConfig.baseUrl}/get_pemilih.php';
      if (search != null && search.isNotEmpty) {
        url += '?search=$search';
      }
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        List<dynamic> rawData = data['data'];
        return rawData.map((e) => PemilihModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Fungsi uploadFoto yang di-upgrade agar mendukung Flutter Web (PlatformFile)
  static Future<String?> uploadFoto(PlatformFile imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/upload_foto.php'),
      );

      // Menggunakan dari bytes agar aman dieksekusi di localhost / browser web
      if (imageFile.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'foto',
            imageFile.bytes!,
            filename: imageFile.name,
          ),
        );
      } else {
        return null;
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true) {
          // Mengembalikan nama file baru atau full URL dari upload_foto.php
          return result['foto']; 
        }
      }
      return null;
    } catch (e) {
      print("ERROR UPLOAD FOTO: $e");
      return null;
    }
  }

// ==================== ADMIN CRUD KANDIDAT (UPDATE - FIXED HEADERS) ====================
  
  static Future<bool> tambahKandidat(Map<String, dynamic> data, {PlatformFile? imageFile}) async {
    try {
      if (imageFile != null) {
        String? uploadedUrl = await uploadFoto(imageFile);
        if (uploadedUrl != null) {
          data['foto'] = uploadedUrl; 
        } else {
          return false; 
        }
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/data_calon.php?action=create'),
        headers: {
          'Content-Type': 'application/json', // 👈 WAJIB ADA INI BIAR PHP BISA BACA
        },
        body: jsonEncode(data),
      );
      final respData = jsonDecode(response.body);
      return respData['success'] == true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateKandidat(int id, Map<String, dynamic> data, {PlatformFile? imageFile}) async {
    try {
      data['id'] = id;
      
      if (imageFile != null) {
        String? uploadedUrl = await uploadFoto(imageFile);
        if (uploadedUrl != null) {
          data['foto'] = uploadedUrl; 
        } else {
          return false;
        }
      }

      print("📤 DATA YANG DIKIRIM KE PHP: ${jsonEncode(data)}");

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/data_calon.php?action=update'),
        headers: {
          'Content-Type': 'application/json', // 👈 WAJIB ADA INI BIAR PHP BISA BACA ID & BIODATA
        },
        body: jsonEncode(data),
      );
      
      print("📥 RESPONS DARI SERVER PHP: ${response.body}");

      final respData = jsonDecode(response.body);
      return respData['success'] == true;
    } catch (e) {
      print("❌ EXCEPTION ERROR AT FLUTTER: $e");
      return false;
    }
  }

  static Future<bool> hapusKandidat(int id) async {
    try {
      print("MENGHAPUS ID = $id");

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/data_calon.php?action=delete'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': id}),
      );

      print("STATUS CODE = ${response.statusCode}");
      print("RESPONSE = ${response.body}");

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("DELETE ERROR = $e");
      return false;
    }
  }

  // Mengambil status pengumuman (Dipakai User & Admin)
  static Future<String> getStatusPengumuman() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/status_pengumuman.php'));
      final data = jsonDecode(response.body);
      return data['status'] ?? 'hidden'; // mengembalikan 'visible' atau 'hidden'
    } catch (e) {
      return 'hidden';
    }
  }

  // Mengubah status pengumuman (Dipakai Admin)
  static Future<bool> updateStatusPengumuman(String status) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/status_pengumuman.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      return false;
    }
  }

// ==================== RESET VOTING (ADMIN) ====================
  
  static Future<bool> resetVoting(String kategori) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/reset_voting.php'),
        headers: {
          'Content-Type': 'application/json', // 👈 WAJIB DITAMBAHKAN BIAR PHP BISA MEMBACA BODY JSON
        },
        body: jsonEncode({'kategori': kategori}),
      );
      
      print("📥 RESET VOTING RESPONSE: ${response.body}"); // Tambahkan log untuk mempermudah debugging
      
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("❌ RESET VOTING ERROR: $e");
      return false;
    }
  }
}