import 'absen_model.dart';

class Logbook {
  final int id;
  final int weekNumber;
  final String? kegiatan;
  final String filePdf;
  final int dataPklId;
  final DataPklInfo? dataPkl;

  Logbook({
    required this.id,
    required this.weekNumber,
    this.kegiatan,
    required this.filePdf,
    required this.dataPklId,
    this.dataPkl,
  });

  factory Logbook.fromJson(Map<String, dynamic> json) {
    return Logbook(
      id: json['id'] as int? ?? 0,
      weekNumber: json['week_number'] as int? ?? 0,
      kegiatan: json['kegiatan'] as String?,
      filePdf: json['file_pdf'] as String? ?? '',
      dataPklId: json['data_pkl_id'] as int? ?? 0,
      dataPkl: json['data_pkl'] != null
          ? DataPklInfo.fromJson(json['data_pkl'] as Map<String, dynamic>)
          : null,
    );
  }

  String? get namaMahasiswa => dataPkl?.mahasiswa?.name;
}
