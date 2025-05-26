import 'dart:convert';
import 'package:flutter/material.dart'; // Diperlukan untuk BuildContext di performLogout
import 'package:http/http.dart' as http;
import '../utils/token_manager.dart';
import '../models/user_model.dart'; // Import User model
import 'package:provider/provider.dart'; // Import Provider
import '../providers/user_data_provider.dart'; // Import UserDataProvider
import '../screens/auth_screen.dart'; // Pastikan path ini benar

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  // Metode register tetap sama
  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 201 && responseData['status'] == true) {
        return {'success': true, 'message': responseData['message'], 'data': responseData};
      } else {
        String errorMessage = "Registrasi gagal.";
        if (responseData is Map && responseData.containsKey('message')) {
            errorMessage = responseData['message'];
        } else if (responseData is Map && responseData.containsKey('errors')) {
            Map<String, dynamic> errors = responseData['errors'];
            errorMessage = errors.entries.map((e) {
              if (e.value is List) {return (e.value as List).join(', ');}
              return e.value.toString();
            }).join('\n');
        }
        return {'success': false, 'message': errorMessage, 'data': responseData};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi atau parsing: ${e.toString()}'};
    }
  }


  // --- MODIFIKASI LOGIN untuk memanggil fetchUserProfile ---
  Future<Map<String, dynamic>> login(BuildContext context, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 201 && responseData['status'] == true) {
        await TokenManager.saveToken(responseData['token'], responseData['role']);
        // Setelah token disimpan, panggil fetchUserProfile
        // Menggunakan Provider untuk mendapatkan instance UserDataProvider
        bool profileFetched = await Provider.of<UserDataProvider>(context, listen: false).fetchUserProfile();
        if (!profileFetched) {
          // Handle jika profil gagal diambil, mungkin logout lagi atau tampilkan pesan
          print("Gagal mengambil profil pengguna setelah login.");
        }
        return {'success': true, 'message': responseData['message'], 'data': responseData};
      } else {
        String errorMessage = "Login Gagal.";
        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        return {'success': false, 'message': errorMessage, 'data': responseData};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi atau parsing: ${e.toString()}'};
    }
  }

  // --- METHOD BARU UNTUK MENGAMBIL PROFIL USER ---
  // lib/services/auth_service.dart
static Future<User?> getUserProfile() async {
  final String? token = await TokenManager.getToken();
  if (token == null) {
    print("[AuthService.getUserProfile] GAGAL: Token tidak ditemukan di SharedPreferences."); // Lebih jelas
    return null;
  }
  print("[AuthService.getUserProfile] INFO: Menggunakan token: $token");

  try {
    final response = await http.get(
      Uri.parse('$_baseUrl/user'), // Pastikan endpoint ini benar dan dilindungi auth:sanctum
      headers: {
        'Authorization': 'Bearer $token', // Sangat penting
        'Accept': 'application/json',
      },
    );

    print("[AuthService.getUserProfile] INFO: Status Code dari /api/user: ${response.statusCode}");
    print("[AuthService.getUserProfile] INFO: Response Body dari /api/user: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      User user = User.fromJson(responseData);
      print("[AuthService.getUserProfile] SUKSES: User berhasil diparsing: ${user.name}, email: ${user.email}");
      return user;
    } else {
      print("[AuthService.getUserProfile] GAGAL: Mengambil profil user dari server. Status: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("[AuthService.getUserProfile] EXCEPTION: Saat memanggil API /user: $e");
    return null;
  }
}
  // --- AKHIR METHOD BARU ---

  static Future<void> performLogout(BuildContext context) async {
    final String? token = await TokenManager.getToken();
    if (token != null) {
      try {
        await http.post(
          Uri.parse('$_baseUrl/logout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
      } catch (e) {
        print('Error saat menghubungi server untuk logout: $e');
      }
    }
    // Panggil clearUser dari UserDataProvider
    await Provider.of<UserDataProvider>(context, listen: false).clearUser();

    if (Navigator.of(context).mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }
}