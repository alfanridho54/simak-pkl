import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/datapkl_model.dart';
import '../utils/token_manager.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<DataPkl>> getDataPkl({required String role}) async {
    final String? token = await TokenManager.getToken();

    if (role != 'dosen' && role != 'mahasiswa') {
      throw Exception('Role tidak valid untuk mengambil data PKL.');
    }

    final Uri uri = Uri.parse('$_baseUrl/data-pkl/$role');

    try {
      final response = await http.get(
        uri,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseBody = json.decode(response.body);
        if (responseBody is Map<String, dynamic> && responseBody.containsKey('data') && responseBody['data'] is List) {
            final List<dynamic> jsonData = responseBody['data'];
            return jsonData.map((item) => DataPkl.fromJson(item as Map<String, dynamic>)).toList();
        } else if (responseBody is List<dynamic>) {
            final List<dynamic> jsonData = responseBody;
            return jsonData.map((item) => DataPkl.fromJson(item as Map<String, dynamic>)).toList();
        } else {
            throw Exception('Struktur JSON respons tidak sesuai untuk data PKL.');
        }
      } else {
        throw Exception('Gagal memuat data PKL untuk role $role. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data PKL untuk role $role: $e');
    }
  }
}