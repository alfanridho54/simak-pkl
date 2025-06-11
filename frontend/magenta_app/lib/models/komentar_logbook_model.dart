import 'user_model.dart';

class KomentarLogbook {
  final int id;
  final String comment;
  final int logbookId;
  final int dosenId;
  final User? dosen; 
  final String? createdAt;

  KomentarLogbook({
    required this.id,
    required this.comment,
    required this.logbookId,
    required this.dosenId,
    this.dosen,
    this.createdAt,
  });

  factory KomentarLogbook.fromJson(Map<String, dynamic> json) {
    return KomentarLogbook(
      id: json['id'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      logbookId: json['logbook_id'] as int? ?? 0,
      dosenId: json['dosen_id'] as int? ?? 0,
      dosen: json['dosen'] != null
          ? User.fromJson(json['dosen'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String?,
    );
  }
}