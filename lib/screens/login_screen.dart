import 'package:flutter/material.dart';
import 'package:trabajoexp/services/auth_service.dart';
import 'package:trabajoexp/services/user_service.dart'; // 👈 Importa el UserService
import 'package:trabajoexp/model/user_model.dart'; // 👈 Importa tu modelo User si hace falta

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;
  bool _rememberMe = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = await _authService.login(_emailController.text, _passwordController.text);

        await UserService().setUser(user.toJson());

        Navigator.pushReplacementNamed(context, '/dashboard');
      } catch (e) {
        setState(() => _error = 'Correo o contraseña incorrectos');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, Color(0xFFE0F7FA)]),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        'https://i.postimg.cc/FRLT9nhV/image-removebg-preview-3.png',
                        height: 100,
                      ),
                      const SizedBox(height: 16),
                      const Text('Iniciar Sesión', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      if (_error != null) ...[
                        const SizedBox(height: 8),
                        Text(_error!, style: const TextStyle(color: Colors.red)),
                      ],
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingrese su correo';
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) return 'Ingrese un correo válido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Contraseña'),
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty ? 'Ingrese su contraseña' : null,
                      ),
                      CheckboxListTile(
                        title: const Text('Recordarme'),
                        value: _rememberMe,
                        onChanged: (val) => setState(() => _rememberMe = val!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                        child: const Text("¿No tienes cuenta? Regístrate aquí"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}