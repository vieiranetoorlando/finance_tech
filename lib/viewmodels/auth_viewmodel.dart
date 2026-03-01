import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Lógica de Login para a View usar
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    String? error = await _authService.login(email, password);

    _isLoading = false;
    notifyListeners();

    if (error != null) {
      return false; // Login falhou
    }
    return true; // Login ok
  }

  // Lógica de Cadastro para a View usar
  Future<String?> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    String? error = await _authService.register(email, password);

    _isLoading = false;
    notifyListeners();
    return error;
  }
}
