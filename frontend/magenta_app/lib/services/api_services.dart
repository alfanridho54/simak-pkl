import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/laporan_pkl_model.dart';
import '../models/komentar_laporan_model.dart';
import 'package:path/path.dart' as path;

import '../models/absen_model.dart';
import '../models/datapkl_model.dart';
import '../models/logbook_model.dart';
import '../models/user_model.dart';
import '../utils/token_manager.dart';
import '../models/komentar_logbook_model.dart';
import '../models/dashboard_model.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

 // Data PKL
   static Future<List<DataPkl>> getDataPkl({required String role}) async {
    final String? token = await TokenManager.getToken();
    if (token == null) throw Exception('Autentikasi diperlukan.');

    Uri uri;
    if (role == 'admin') {
      uri = Uri.parse('$_baseUrl/data_pkl');
    } else if (role == 'dosen' || role == 'mahasiswa') {
      uri = Uri.parse('$_baseUrl/data-pkl/$role');
    } else {
      throw Exception('Role tidak valid untuk mengambil data PKL.');
    }
    
    print('[ApiService.getDataPkl] Fetching data for role "$role" from: $uri');

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
    throw Exception('Gagal memuat data PKL. Status: ${response.statusCode}');
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

  // komentar logbook
  static Future<List<KomentarLogbook>> getKomentarByLogbook(int logbookId) async {
        final String? token = await TokenManager.getToken();
        if (token == null) throw Exception('Autentikasi diperlukan.');
        
        final Uri uri = Uri.parse('$_baseUrl/komentar-logbook/by-logbook/$logbookId');
        
        try {
            final response = await http.get(uri, headers: {
                'Authorization': 'Bearer $token', 'Accept': 'application/json',
            });
            
            if (response.statusCode == 200) {
                final dynamic body = jsonDecode(response.body);
                if (body['success'] == true && body['data'] is List) {
                    return (body['data'] as List)
                        .map((item) => KomentarLogbook.fromJson(item as Map<String, dynamic>))
                        .toList();
                }
                throw Exception('Format respons komentar tidak valid.');
            }
            throw Exception('Gagal memuat komentar. Status: ${response.statusCode}');
        } catch (e) {
            rethrow;
        }
    }

    static Future<Map<String, dynamic>> createKomentarLogbook(Map<String, String> data) async {
        final String? token = await TokenManager.getToken();
        if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
        
        final Uri uri = Uri.parse('$_baseUrl/komentar-logbook');
        
        try {
            final response = await http.post(uri,
                headers: {
                    'Authorization': 'Bearer $token',
                    'Accept': 'application/json',
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(data));
            
            return jsonDecode(response.body);
        } catch (e) {
            return {'success': false, 'message': 'Error: ${e.toString()}'};
        }
    }

    static Future<Map<String, dynamic>> deleteKomentarLogbook(int komentarId) async {
        final String? token = await TokenManager.getToken();
        if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
        
        final Uri uri = Uri.parse('$_baseUrl/komentar-logbook/$komentarId');
        
        try {
            final response = await http.delete(uri,
                headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
            
            return jsonDecode(response.body);
        } catch (e) {
            return {'success': false, 'message': 'Error: ${e.toString()}'};
        }
    }

     // --- CRUD LAPORAN PKL ---
  static Future<List<LaporanPkl>> getLaporanPkl() async {
    final token = await TokenManager.getToken();
    if (token == null) throw Exception('Autentikasi diperlukan.');
    final response = await http.get(Uri.parse('$_baseUrl/laporan-pkl'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true && body['data'] is List) {
        return (body['data'] as List).map((item) => LaporanPkl.fromJson(item)).toList();
      }
    }
    throw Exception('Gagal memuat Laporan PKL');
  }

  static Future<Map<String, dynamic>> createLaporanPkl(Map<String, String> data, File file) async {
    final token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/laporan-pkl'));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.fields.addAll(data);
    request.files.add(await http.MultipartFile.fromPath('file_attachment', file.path, filename: path.basename(file.path)));
    var res = await request.send();
    return jsonDecode(await res.stream.bytesToString());
  }

  static Future<Map<String, dynamic>> deleteLaporanPkl(int id) async {
    final token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    final response = await http.delete(Uri.parse('$_baseUrl/laporan-pkl/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
    return jsonDecode(response.body);
  }

  // --- CRUD KOMENTAR LAPORAN ---
  static Future<List<KomentarLaporan>> getKomentarByLaporan(int laporanId) async {
    final token = await TokenManager.getToken();
    if (token == null) throw Exception('Autentikasi diperlukan.');
    final response = await http.get(Uri.parse('$_baseUrl/komentar-laporan/by-laporan/$laporanId'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true && body['data'] is List) {
        return (body['data'] as List).map((item) => KomentarLaporan.fromJson(item)).toList();
      }
    }
    throw Exception('Gagal memuat Komentar Laporan');
  }

  static Future<Map<String, dynamic>> createKomentarLaporan(Map<String, String> data) async {
    final token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    final response = await http.post(Uri.parse('$_baseUrl/komentar-laporan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteKomentarLaporan(int id) async {
    final token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    final response = await http.delete(Uri.parse('$_baseUrl/komentar-laporan/$id'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
    return jsonDecode(response.body);
  }

  // --- DOWNLOAD FILE LAPORAN ---
 static Future<String?> downloadLaporanPkl(String fileUrl, String fileName) async {
    final String? token = await TokenManager.getToken();
    if (token == null) throw Exception('Autentikasi diperlukan.');

    final Directory dir = await getTemporaryDirectory();
    final String filePath = "${dir.path}/$fileName";
    
    final dio = Dio();
    try {
      print("[ApiService] Downloading attachment to TEMPORARY CACHE: $filePath");
      await dio.download(
        fileUrl,
        filePath,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );
      return filePath;
    } on DioException catch (e) {
      print("Dio download error: ${e.response?.data ?? e.message}");
      throw Exception("Gagal mengunduh file lampiran.");
    }
  }

  // DASHBOARD
  static Future<DashboardData> getDashboardData() async {
        final String? token = await TokenManager.getToken();
        if (token == null) throw Exception('Autentikasi diperlukan.');
        
        final Uri uri = Uri.parse('$_baseUrl/dashboard');
        try {
            final response = await http.get(uri, headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
            });

            if (response.statusCode == 200) {
                final body = jsonDecode(response.body);
                if (body['success'] == true && body['data'] != null) {
                    return DashboardData.fromJson(body['data']);
                }
            }
            throw Exception('Gagal memuat data dashboard.');
        } catch (e) {
            rethrow;
        }
    }

    // Profile
    static Future<Map<String, dynamic>> updateProfile(
      {File? avatar, Map<String, String>? data}) async {
    final String? token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    
    final Uri uri = Uri.parse('$_baseUrl/profile/update');
    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      if (data != null) {
        request.fields.addAll(data);
      }
      if (avatar != null) {
        request.files.add(await http.MultipartFile.fromPath('avatar', avatar.path, filename: path.basename(avatar.path)));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // admin
  static Future<List<User>> getUsers() async {
    final token = await TokenManager.getToken();
    if (token == null) throw Exception('Autentikasi diperlukan.');
    final response = await http.get(Uri.parse('$_baseUrl/users'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true && body['data'] is List) {
        return (body['data'] as List).map((item) => User.fromJson(item)).toList();
      }
    }
    throw Exception('Gagal memuat daftar pengguna.');
  }

  static Future<Map<String, dynamic>> createUser(Map<String, String> userData) async {
    final token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    
    final response = await http.post(Uri.parse('$_baseUrl/user-management'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateUser(int userId, Map<String, String> userData) async {
    final token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    final response = await http.put(Uri.parse('$_baseUrl/user-management/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteUser(int userId) async {
    final token = await TokenManager.getToken();
    if (token == null) return {'success': false, 'message': 'Autentikasi diperlukan.'};
    final response = await http.delete(Uri.parse('$_baseUrl/user-management/$userId'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
    return jsonDecode(response.body);
  }


}