import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


import '../models/absen_model.dart';
import '../models/datapkl_model.dart';
import '../models/logbook_model.dart';
import '../models/user_model.dart';
import '../utils/token_manager.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

 // Data PKL
  static Future<List<DataPkl>> getDataPkl({required String role}) async {
    final String? token = await TokenManager.getToken();
    if (token == null) throw Exception('Autentikasi diperlukan.');
    if (role != 'dosen' && role != 'mahasiswa') {
      throw Exception('Role tidak valid untuk mengambil data PKL.');
    }
    final Uri uri = Uri.parse('$_baseUrl/data-pkl/$role');
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      if (body['success'] == true && body['data'] is List) {
        return (body['data'] as List)
            .map((item) => DataPkl.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Format respons data PKL tidak valid.');
    }
    throw Exception(
        'Gagal memuat data PKL. Status: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> createDataPkl(
      Map<String, dynamic> pklData) async {
    final String? token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    final Uri uri = Uri.parse('$_baseUrl/data_pkl');
    try {
      final response = await http.post(uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(pklData));
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> updateDataPkl(
      int id, Map<String, dynamic> pklData) async {
    final String? token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    final Uri uri = Uri.parse('$_baseUrl/data_pkl/$id');
    try {
      final response = await http.put(uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(pklData));
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> deleteDataPkl(int id) async {
    final String? token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    final Uri uri = Uri.parse('$_baseUrl/data_pkl/$id');
    try {
      final response = await http.delete(uri, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }


  // Dosen
  static Future<List<User>> getDosenList() async {
    final String? token = await TokenManager.getToken();
    if (token == null) throw Exception('Autentikasi diperlukan.');
    final Uri uri = Uri.parse('$_baseUrl/users?role=dosen');
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      if (body['data'] is List) {
        return (body['data'] as List)
            .map((item) => User.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Format respons daftar dosen tidak valid.');
    }
    throw Exception(
        'Gagal memuat daftar dosen. Status: ${response.statusCode}');
  }


  // Absen
  static Future<List<Absen>> getAbsenData() async {
    final String? token = await TokenManager.getToken();
    if (token == null) throw Exception('Autentikasi diperlukan.');
    final Uri uri = Uri.parse('$_baseUrl/absen');
    final response = await http.get(uri,
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      if (body['success'] == true && body['data'] is List) {
        return (body['data'] as List)
            .map((item) => Absen.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Format respons absen tidak valid.');
    }
    throw Exception('Gagal memuat data absen. Status: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> createAbsen(
      Map<String, dynamic> absenData) async {
    final String? token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    final Uri uri = Uri.parse('$_baseUrl/absen');
    try {
      final response = await http.post(uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(absenData));
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> updateAbsen(
      int id, Map<String, dynamic> absenData) async {
    final String? token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    final Uri uri = Uri.parse('$_baseUrl/absen/$id');
    try {
      final response = await http.put(uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(absenData));
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> deleteAbsen(int id) async {
    final String? token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    final Uri uri = Uri.parse('$_baseUrl/absen/$id');
    try {
      final response = await http
          .delete(uri, headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }


  // Logbook
  static Future<List<Logbook>> getLogbooks() async {
    final String? token = await TokenManager.getToken();
    if (token == null) throw Exception('Autentikasi diperlukan.');
    final Uri uri = Uri.parse('$_baseUrl/logbook');
    final response = await http.get(uri,
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      if (body['success'] == true && body['data'] is List) {
        return (body['data'] as List)
            .map((item) => Logbook.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Format respons logbook tidak valid.');
    }
    throw Exception('Gagal memuat logbook. Status: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> createLogbook(Map<String, String> logbookData) async {
        final String? token = await TokenManager.getToken();
        if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
        final Uri uri = Uri.parse('$_baseUrl/logbook');
        try {
            final response = await http.post(uri,
                headers: {
                    'Authorization': 'Bearer $token',
                    'Accept': 'application/json',
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(logbookData));
            return jsonDecode(response.body);
        } catch (e) {
            return {'success': false, 'message': 'Error: ${e.toString()}'};
        }
    }
    
    // --- UPDATE LOGBOOK ---
    static Future<Map<String, dynamic>> updateLogbook(int id, Map<String, String> logbookData) async {
        final String? token = await TokenManager.getToken();
        if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
        final Uri uri = Uri.parse('$_baseUrl/logbook/$id');
        try {
            final response = await http.put(uri, 
                headers: {
                    'Authorization': 'Bearer $token',
                    'Accept': 'application/json',
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(logbookData));
            return jsonDecode(response.body);
        } catch (e) {
            return {'success': false, 'message': 'Error: ${e.toString()}'};
        }
    }

    // --- DOWNLOAD PDF ---
   static Future<String?> downloadLogbookPDF(int logbookId, String fileName) async {
        final String? token = await TokenManager.getToken();
        if (token == null) throw Exception('Autentikasi diperlukan.');  
        final Uri uri = Uri.parse('$_baseUrl/logbook/$logbookId/pdf');
        final Directory dir = await getTemporaryDirectory();
        final String filePath = "${dir.path}/$fileName";
        
        final dio = Dio();
        try {
            print("[ApiService] Downloading to TEMPORARY CACHE: $filePath");
            await dio.download(
                uri.toString(),
                filePath,
                options: Options(
                    headers: {'Authorization': 'Bearer $token'},
                    responseType: ResponseType.bytes,
                ),
            );
            print("[ApiService] File PDF diunduh ke: $filePath");
            return filePath;
        } on DioException catch (e) {
            throw Exception("Gagal mengunduh file PDF: ${e.response?.statusMessage ?? e.message}");
        } catch (e) {
            throw Exception("Terjadi kesalahan tidak dikenal saat mengunduh: $e");
        }
    }

  static Future<Map<String, dynamic>> deleteLogbook(int id) async {
    final String? token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    final Uri uri = Uri.parse('$_baseUrl/logbook/$id'); 
    try {
      final response = await http.delete(uri,
          headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }


}