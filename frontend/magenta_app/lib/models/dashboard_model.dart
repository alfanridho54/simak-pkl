import 'package:magenta_app/models/logbook_model.dart';


class DashboardData {
  // Untuk Mahasiswa
  final String? companyName;
  final String? dosenPembimbing;
  final int? totalLogbook;

  // Untuk Dosen
  final int? jumlahBimbingan;
  final int? logbookBaru;
  final List<Logbook>? latestActivities; 

  // Untuk Admin
  final int? totalUsers;
  final int? totalMahasiswa;
  final int? totalDosen;

  DashboardData({
    this.companyName,
    this.dosenPembimbing,
    this.totalLogbook,
    this.jumlahBimbingan,
    this.logbookBaru,
    this.latestActivities,
    this.totalUsers,
    this.totalMahasiswa,
    this.totalDosen,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      companyName: json['company_name'] as String?,
      dosenPembimbing: json['dosen_pembimbing'] as String?,
      totalLogbook: json['total_logbook'] as int?,
      jumlahBimbingan: json['jumlah_bimbingan'] as int?,
      logbookBaru: json['logbook_baru'] as int?,
      latestActivities: (json['latest_activities'] as List<dynamic>?)
          ?.map((e) => Logbook.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalUsers: json['total_users'] as int?,
      totalMahasiswa: json['total_mahasiswa'] as int?,
      totalDosen: json['total_dosen'] as int?,
    );
  }
}
