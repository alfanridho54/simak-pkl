import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/datapkl_model.dart';
import '../models/absen_model.dart';
import '../utils/token_manager.dart';
import '../models/user_model.dart';

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

  static Future<Map<String, dynamic>> createDataPkl(Map<String, dynamic> pklData) async {
    final String? token = await TokenManager.getToken();
    if (token == null) throw Exception('Autentikasi diperlukan.');

    final Uri uri = Uri.parse('$_baseUrl/data-pkl/create');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pklData),
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseBody['success'] == true) {
          return {
            'success': true,
            'message': responseBody['message'],
            'data': DataPkl.fromJson(responseBody['data'])
          };
        }
      }
      return {
        'success': false,
        'message': responseBody['message'] ?? 'Gagal menambahkan data PKL',
        'errors': responseBody['errors']
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> updateDataPkl(int id, Map<String, dynamic> pklData) async {
    final String? token = await TokenManager.getToken();
    if (token == null) throw Exception('Autentikasi diperlukan.');

    final Uri uri = Uri.parse('$_baseUrl/data-pkl/update/$id');
    try {
      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pklData),
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseBody['success'] == true) {
          return {
            'success': true,
            'message': responseBody['message'],
            'data': DataPkl.fromJson(responseBody['data'])
          };
        }
      }
      return {
        'success': false,
        'message': responseBody['message'] ?? 'Gagal mengubah data PKL',
        'errors': responseBody['errors']
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> deleteDataPkl(int id) async {
    final String? token = await TokenManager.getToken();
    if (token == null) throw Exception('Autentikasi diperlukan.');

    final Uri uri = Uri.parse('$_baseUrl/data-pkl/delete/$id');
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == true) {
        return {'success': true, 'message': responseBody['message']};
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Gagal menghapus data PKL'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<List<User>> getDosenList() async {
    final String? token = await TokenManager.getToken();

    if (token == null) {
      throw Exception('Autentikasi diperlukan untuk mengambil daftar dosen.');
    }

    final Uri uri = Uri.parse('$_baseUrl/list-dosen');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseBody = json.decode(response.body);

        if (responseBody is Map<String, dynamic> &&
            responseBody.containsKey('success') &&
            responseBody['success'] == true &&
            responseBody.containsKey('data') &&
            responseBody['data'] is List) {
          final List<dynamic> jsonData = responseBody['data'];
          return jsonData.map((item) => User.fromJson(item as Map<String, dynamic>)).toList();
        } else if (responseBody is List<dynamic>) {
          final List<dynamic> jsonData = responseBody;
          return jsonData.map((item) => User.fromJson(item as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Gagal memuat daftar dosen: ${responseBody is Map ? responseBody['message'] : 'Format respons tidak dikenal.'}');
        }
      } else {
        String errorMessage = 'Gagal memuat daftar dosen.';
        try {
          final errorBody = json.decode(response.body);
          if (errorBody is Map && errorBody.containsKey('message')) {
            errorMessage = errorBody['message'];
          }
        } catch (_) {}
        throw Exception('Gagal memuat daftar dosen. Status: ${response.statusCode}. Pesan: $errorMessage');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Absen>> getAbsenData() async {
    final String? token = await TokenManager.getToken();

    if (token == null) {
      throw Exception('Autentikasi diperlukan untuk mengambil data absen.');
    }

    final Uri uri = Uri.parse('$_baseUrl/absen');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseBody = json.decode(response.body);
        if (responseBody is Map<String, dynamic> &&
            responseBody.containsKey('success') &&
            responseBody['success'] == true &&
            responseBody.containsKey('data') &&
            responseBody['data'] is List) {
          final List<dynamic> jsonData = responseBody['data'];
          return jsonData.map((item) => Absen.fromJson(item as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Gagal memuat data absen: ${responseBody['message'] ?? 'Format respons tidak dikenal.'}');
        }
      } else {
        throw Exception('Gagal memuat data absen. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data absen: $e');
    }
  }
  // --- CREATE (STORE) ABSEN ---
  static Future<Map<String, dynamic>> createAbsen(Map<String, dynamic> absenData) async {
    final String? token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};

    final Uri uri = Uri.parse('$_baseUrl/absen/create'); 
    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(absenData), 
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 201 || (response.statusCode == 200 && responseBody['success'] == true) ) { // Laravel store bisa 201
        return {
          'success': true,
          'message': responseBody['message'] ?? 'Absen berhasil disimpan',
          'data': Absen.fromJson(responseBody['data'])
        };
      } else {
         return {
          'success': false,
          'message': responseBody['message'] ?? 'Gagal menyimpan absen',
          'errors': responseBody['errors'] 
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // --- UPDATE ABSEN ---
  static Future<Map<String, dynamic>> updateAbsen(int id, Map<String, dynamic> absenData) async {
    final String? token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};

    final Uri uri = Uri.parse('$_baseUrl/absen/update/$id');
    try {
      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(absenData),
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == true) {
        return {
          'success': true,
          'message': responseBody['message'],
          'data': Absen.fromJson(responseBody['data'])
        };
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Gagal mengubah absen',
          'errors': responseBody['errors']
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // --- DELETE ABSEN ---
  static Future<Map<String, dynamic>> deleteAbsen(int id) async {
    final String? token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};

    final Uri uri = Uri.parse('$_baseUrl/absen/delete/$id'); // Endpoint destroy Anda (DELETE /api/absen/{id})
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == true) {
        return {'success': true, 'message': responseBody['message']};
      } else {
        return {'success': false, 'message': responseBody['message'] ?? 'Gagal menghapus absen'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}

