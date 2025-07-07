import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trabajoexp/enviroments/env.dart';
import 'package:trabajoexp/model/user_model.dart';

class AuthService {
  final String baseUrl = '${Env.baseUrl}/users';

  Future<User> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['user'] != null) {
        return User.fromJson(data['user']);
      } else {
        throw Exception('Usuario no encontrado en la respuesta');
      }
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  Future<User> register(User user) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Error al registrar usuario');
    }
  }
}