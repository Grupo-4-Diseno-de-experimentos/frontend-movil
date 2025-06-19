import 'package:flutter/material.dart';
import 'package:trabajoexp/model/user_model.dart';
import 'package:trabajoexp/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'USER';
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  void _register() async {
    if (_formKey.currentState!.validate() && _termsAccepted && _privacyAccepted) {
      final user = User(
        name: _nameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _role,
        createdAt: DateTime.now(),
      );

      try {
        await _authService.register(user);
        if (_role == 'nutricionist') {
          Navigator.pushReplacementNamed(context, '/profile');
        } else {
          Navigator.pushReplacementNamed(context, '/mealplans');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar usuario')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar los Términos y la Privacidad')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nombre')),
              TextFormField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Apellido')),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Correo')),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              DropdownButtonFormField(
                value: _role,
                items: const [
                  DropdownMenuItem(value: 'USER', child: Text('Usuario')),
                  DropdownMenuItem(value: 'NUTRICIONIST', child: Text('Nutricionista')),
                ],
                onChanged: (value) => setState(() => _role = value!),
                decoration: const InputDecoration(labelText: 'Rol'),
              ),
              CheckboxListTile(
                title: const Text('Acepto los Términos y Condiciones'),
                value: _termsAccepted,
                onChanged: (val) => setState(() => _termsAccepted = val!),
              ),
              CheckboxListTile(
                title: const Text('Acepto la Política de Privacidad'),
                value: _privacyAccepted,
                onChanged: (val) => setState(() => _privacyAccepted = val!),
              ),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}