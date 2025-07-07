import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  Map<String, dynamic>? _user;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString('user');
    if (storedUser != null) {
      _user = jsonDecode(storedUser);
    }
  }

  Future<void> setUser(Map<String, dynamic> user) async {
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user));
  }

  Map<String, dynamic>? getUser() {
    return _user;
  }

  int? getUserId() {
    return _user?['id'];
  }

  String? getUserRole() {
    return _user?['role'];
  }

  bool isNutricionist() {
    return getUserRole()?.toLowerCase() == 'nutricionist';
  }

  bool isUser() {
    return getUserRole()?.toLowerCase() == 'user';
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  bool isLoggedIn() {
    return _user != null;
  }
}