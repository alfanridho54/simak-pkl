import 'user_model.dart';

class KomentarLaporan {
  final int id;
  final String comment;
  final int laporanPklId;
  final int dosenId;
  final User? dosen;
  final String? createdAt;

  KomentarLaporan({
    required this.id,
    required this.comment,
    required this.laporanPklId,
    required this.dosenId,
    this.dosen,
    this.createdAt,
  });

  factory KomentarLaporan.fromJson(Map<String, dynamic> json) {
    return KomentarLaporan(
      id: json['id'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      laporanPklId: json['laporan_pkl_id'] as int? ?? 0,
      dosenId: json['dosen_id'] as int? ?? 0,
      dosen: json['dosen'] != null
          ? User.fromJson(json['dosen'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String?,
    );
  }
}
