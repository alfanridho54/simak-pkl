class MahasiswaInfo {
  final int id;
  final String name;
  final String? email; // Email bisa jadi null

  MahasiswaInfo({
    required this.id,
    required this.name,
    this.email,
  });

  factory MahasiswaInfo.fromJson(Map<String, dynamic> json) {
    return MahasiswaInfo(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Nama Mahasiswa Tidak Ada',
      email: json['email'] as String?,
    );
  }
}

class DataPklInfo {
  final int id;
  final String? companyName;
  final MahasiswaInfo? mahasiswa; 

  DataPklInfo({
    required this.id,
    this.companyName,
    this.mahasiswa,
  });

  factory DataPklInfo.fromJson(Map<String, dynamic> json) {
    return DataPklInfo(
      id: json['id'] as int? ?? 0,
      companyName: json['company_name'] as String?,
      mahasiswa: json['mahasiswa'] != null
          ? MahasiswaInfo.fromJson(json['mahasiswa'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Absen {
  final int id;
  final String location;
  final String status;
  final String date; 
  final int dataPklId;
  final DataPklInfo? dataPkl; 

  Absen({
    required this.id,
    required this.location,
    required this.status,
    required this.date,
    required this.dataPklId,
    this.dataPkl,
  });

  factory Absen.fromJson(Map<String, dynamic> json) {
    return Absen(
      id: json['id'] as int? ?? 0,
      location: json['location'] as String? ?? 'Lokasi Tidak Ada',
      status: json['status'] as String? ?? 'Status Tidak Ada',
      date: json['date'] as String? ?? 'Tanggal Tidak Ada',
      dataPklId: json['data_pkl_id'] as int? ?? 0,
      dataPkl: json['data_pkl'] != null
          ? DataPklInfo.fromJson(json['data_pkl'] as Map<String, dynamic>)
          : null,
    );
  }

  // Helper untuk mendapatkan nama mahasiswa jika ada
  String? get namaMahasiswa => dataPkl?.mahasiswa?.name;
  String? get namaPerusahaan => dataPkl?.companyName;
}