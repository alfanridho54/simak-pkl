import 'user_info_model.dart';

class DataPkl {
  final int? id;
  final String? company_name;
  final String? company_address;
  final String? contact_person;

  final int? users_id;
  final int? dosen_pembimbing_id;

  final UserInfo? mahasiswa;
  final UserInfo? dosenPembimbing;

  DataPkl({
    this.id,
    this.company_name,
    this.company_address,
    this.contact_person,
    this.users_id,
    this.dosen_pembimbing_id,
    this.mahasiswa,
    this.dosenPembimbing,
  });

  factory DataPkl.fromJson(Map<String, dynamic> json) {
    UserInfo? parsedMahasiswa;
    int? parsedMahasiswaId = json['users_id'] as int?;

    if (json['mahasiswa'] != null && json['mahasiswa'] is Map<String, dynamic>) {
      parsedMahasiswa = UserInfo.fromJson(json['mahasiswa'] as Map<String, dynamic>);
      parsedMahasiswaId ??= parsedMahasiswa.id;
    } else if (json['user'] != null && json['user'] is Map<String, dynamic>) {
      parsedMahasiswa = UserInfo.fromJson(json['user'] as Map<String, dynamic>);
      parsedMahasiswaId ??= parsedMahasiswa.id;
    }

    UserInfo? parsedDosenPembimbing;
    int? parsedDosenPembimbingIdValue = json['dosen_pembimbing_id'] as int?;

    if (json['dosen_pembimbing'] != null && json['dosen_pembimbing'] is Map<String, dynamic>) {
      parsedDosenPembimbing = UserInfo.fromJson(json['dosen_pembimbing'] as Map<String, dynamic>);
      parsedDosenPembimbingIdValue = parsedDosenPembimbing.id;
    } else if (json['dosen_pembimbing'] is int) {
      parsedDosenPembimbingIdValue = json['dosen_pembimbing'] as int?;
    }

    return DataPkl(
      id: json['id'] as int?,
      company_name: json['company_name'] as String?,
      company_address: json['company_address'] as String?,
      contact_person: json['contact_person'] as String?,

      users_id: parsedMahasiswaId,
      dosen_pembimbing_id: parsedDosenPembimbingIdValue,

      mahasiswa: parsedMahasiswa,
      dosenPembimbing: parsedDosenPembimbing,
    );
  }

  String get displayNamaMahasiswa {
    if (mahasiswa?.name != null && mahasiswa!.name != 'N/A') {
      return mahasiswa!.name;
    }
    if (users_id != null) {
      return 'ID Mahasiswa: $users_id';
    }
    return 'N/A';
  }

  String get displayNamaDosen {
    if (dosenPembimbing?.name != null && dosenPembimbing!.name != 'N/A') {
      return dosenPembimbing!.name;
    }
    if (dosen_pembimbing_id != null) {
      return 'ID Dosen: $dosen_pembimbing_id';
    }
    return 'N/A';
  }
}
