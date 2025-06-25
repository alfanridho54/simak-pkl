import 'absen_model.dart';
import 'user_model.dart';

class LaporanPkl {
  final int id;
  final String reportDate;
  final String fileAttachment;
  final String status;
  final int dataPklId;
  final int usersId;
  final User? mahasiswa;
  final DataPklInfo? dataPkl;

  LaporanPkl({
    required this.id,
    required this.reportDate,
    required this.fileAttachment,
    required this.status,
    required this.dataPklId,
    required this.usersId,
    this.mahasiswa,
    this.dataPkl,
  });

  factory LaporanPkl.fromJson(Map<String, dynamic> json) {
    return LaporanPkl(
      id: json['id'] as int? ?? 0,
      reportDate: json['report_date'] as String? ?? '',
      fileAttachment: json['file_attachment'] as String? ?? '',
      status: json['status'] as String? ?? 'Menunggu',
      dataPklId: json['data_pkl_id'] as int? ?? 0,
      usersId: json['users_id'] as int? ?? 0,
      mahasiswa: json['mahasiswa'] != null
          ? User.fromJson(json['mahasiswa'] as Map<String, dynamic>)
          : null,
      dataPkl: json['data_pkl'] != null
          ? DataPklInfo.fromJson(json['data_pkl'] as Map<String, dynamic>)
          : null,
    );
  }

  String? get namaMahasiswa => mahasiswa?.name ?? dataPkl?.mahasiswa?.name;
}