import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_services.dart';
import '../utils/token_manager.dart';

class UserDataProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  UserDataProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    _currentUser = await TokenManager.getUserData();
    if (_currentUser != null) {
      notifyListeners();
    }
  }

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<bool> fetchUserProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await AuthService.getUserProfile();
      if (user != null) {
        _currentUser = user;
        await TokenManager.saveUserData(user);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      // Handle error
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> clearUser() async {
    _currentUser = null;
    await TokenManager.deleteTokenAndUser();
    notifyListeners();
  }
}