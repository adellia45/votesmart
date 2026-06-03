class UserModel {
  final int id;
  final String username;
  final String? nisNuptk;
  final String role;

  UserModel({
    required this.id,
    required this.username,
    this.nisNuptk,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      nisNuptk: json['nis_nuptk'],
      role: json['role'] ?? 'pemilih',
    );
  }
}

class AdminModel {
  final int id;
  final String username;

  AdminModel({
    required this.id,
    required this.username,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
    );
  }
}

// ==========================================
// KANDIDAT (UDAH DITAMBAH BIODATA)
// ==========================================
class KandidatModel {
  final int id;
  final String nama;
  final String? foto;
  final String visi;
  final String kategori;
  final List<String> misi;
  final String? createdAt;
  
  // ← DATA BIODATA BARU
  final String? kelas;
  final String? alamat;
  final String? noHp;
  final String? email;
  final String? ttl;
  final String? jenisKelamin;
  final String? tentang;
  final String? keahlian;
  final List<String> pengalaman;

  KandidatModel({
    required this.id,
    required this.nama,
    this.foto,
    required this.visi,
    required this.kategori,
    this.misi = const [],
    this.createdAt,
    this.kelas,
    this.alamat,
    this.noHp,
    this.email,
    this.ttl,
    this.jenisKelamin,
    this.tentang,
    this.keahlian,
    this.pengalaman = const [],
  });

  factory KandidatModel.fromJson(Map<String, dynamic> json) {
    // Parse pengalaman
    List<String> pengalamanList = [];
    if (json['pengalaman'] != null) {
      if (json['pengalaman'] is List) {
        pengalamanList = List<String>.from(json['pengalaman']);
      }
    }

    return KandidatModel(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      foto: json['foto'],
      visi: json['visi'] ?? '',
      kategori: json['kategori'] ?? '',
      misi: json['misi'] != null 
          ? List<String>.from(json['misi']) 
          : [],
      createdAt: json['created_at'],
      
      // Biodata
      kelas: json['kelas'],
      alamat: json['alamat'],
      noHp: json['no_hp'],
      email: json['email'],
      ttl: json['ttl'],
      jenisKelamin: json['jenis_kelamin'],
      tentang: json['tentang'],
      keahlian: json['keahlian'],
      pengalaman: pengalamanList,
    );
  }
}

class VoteResultModel {
  final int kandidatId;
  final String nama;
  final int suara;
  final String? foto;

  VoteResultModel({
    required this.kandidatId,
    required this.nama,
    required this.suara,
    this.foto,
  });

  factory VoteResultModel.fromJson(Map<String, dynamic> json) {
    return VoteResultModel(
      kandidatId: json['kandidat_id'] ?? json['id'] ?? 0,
      nama: json['nama'] ?? '',
      suara: json['suara'] ?? json['jumlah'] ?? 0,
      foto: json['foto'],
    );
  }
}

class VoteStatusModel {
  final bool pilketos;
  final bool pilketum;
  
  // ← DATA BARU: Calon yang dipilih
  final int? pilketosId;
  final String? pilketosNama;
  final String? pilketosFoto;
  
  final int? pilketumId;
  final String? pilketumNama;
  final String? pilketumFoto;

  VoteStatusModel({
    required this.pilketos,
    required this.pilketum,
    this.pilketosId,
    this.pilketosNama,
    this.pilketosFoto,
    this.pilketumId,
    this.pilketumNama,
    this.pilketumFoto,
  });

  bool get sudahSemua => pilketos && pilketum;

  factory VoteStatusModel.fromJson(Map<String, dynamic> json) {
    return VoteStatusModel(
      pilketos: json['pilketos'] ?? false,
      pilketum: json['pilketum'] ?? false,
      pilketosId: json['pilketos_id'],
      pilketosNama: json['pilketos_nama'],
      pilketosFoto: json['pilketos_foto'],
      pilketumId: json['pilketum_id'],
      pilketumNama: json['pilketum_nama'],
      pilketumFoto: json['pilketum_foto'],
    );
  }
}

class HasilVotingModel {
  final List<VoteResultModel> kandidat;
  final int totalSuara;
  final int totalPemilih;

  HasilVotingModel({
    required this.kandidat,
    required this.totalSuara,
    this.totalPemilih = 0,
  });

  factory HasilVotingModel.fromJson(Map<String, dynamic> json) {
    return HasilVotingModel(
      kandidat: (json['kandidat'] as List?)
              ?.map((e) => VoteResultModel.fromJson(e))
              .toList() ??
          [],
      totalSuara: json['total_suara'] ?? 0,
      totalPemilih: json['total_pemilih'] ?? 0,
    );
  }
}

class PemilihModel {
  final int id;
  final String username;
  final String? nisNuptk;
  final bool sudahVoting;

  PemilihModel({
    required this.id,
    required this.username,
    this.nisNuptk,
    required this.sudahVoting,
  });

  factory PemilihModel.fromJson(Map<String, dynamic> json) {
    int statusPilketos = json['status_pilketos'] ?? 0;
    int statusPilketum = json['status_pilketum'] ?? 0;
    
    return PemilihModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      nisNuptk: json['nis_nuptk'],
      sudahVoting: (statusPilketos == 1 || statusPilketum == 1), 
    );
  }
}