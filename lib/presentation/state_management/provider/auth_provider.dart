import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/domain/usecases/login_usecase.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  bool _isAuthenticated = false;
  int userId = 0;

  AuthProvider({required this.loginUseCase});

  bool get isAuthenticated => _isAuthenticated;

  Future<void> _saveAuthState(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setBool('isAuthenticated', true);
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('userId');
    final storedIsAuthenticated = prefs.getBool('isAuthenticated') ?? false;

    if (storedIsAuthenticated && storedUserId != null) {
      userId = storedUserId;
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final result = await loginUseCase(username, password);
    return result.fold((left) {
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }, (right) async {
      userId = right;
      _isAuthenticated = true;
      await _saveAuthState(userId);
      notifyListeners();
      return true;
    });
  }

  void logout() async {
    _isAuthenticated = false;
    userId = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('isAuthenticated');
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    await _loadAuthState();
  }
}
