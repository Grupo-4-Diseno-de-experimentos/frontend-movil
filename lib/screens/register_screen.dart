import 'package:flutter/material.dart';
import 'package:trabajoexp/model/user_model.dart';
import 'package:trabajoexp/services/auth_service.dart';
import 'package:trabajoexp/services/user_service.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _role = 'USER';
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  String termsText = '''Términos y Condiciones de NutriSmart

Al acceder y utilizar la plataforma NutriSmart, usted acepta los siguientes términos y condiciones en su totalidad.

1. Definiciones
"NutriSmart": plataforma web y móvil para planificación alimentaria y conexión con nutricionistas.
"Usuario": persona que usa la Plataforma.
"Nutricionista": profesional registrado.
"Plan de Alimentación": recomendaciones dietéticas personalizadas.

2. Derechos del Usuario
Acceso, generación de planes, acceso a nutricionistas, información clara, modificar/baja cuenta, etc.

3. Obligaciones
Uso adecuado, información veraz, confidencialidad, etc.

4. Restricciones
Uso no comercial, no ingeniería inversa, no malware, no suplantar identidad, no infringir derechos.

Fecha de actualización: 13 de Mayo de 2025.
Contacto: nutrismartcontacto@gmail.com.
''';

  String privacyText = '''Política de Privacidad de NutriSmart

Su privacidad es importante. Explicamos cómo recopilamos, usamos y protegemos su información personal.

1. Información que recopilamos
Registro, perfil, uso, técnica, pago (si aplica).

2. Cómo usamos su información
Gestionar cuenta, personalizar planes, conectar con nutricionistas, mejorar la plataforma, comunicación, seguridad, cumplimiento legal.

3. Compartir su información
Con nutricionistas (si aplica), proveedores, cumplimiento legal, con consentimiento, datos anónimos.

4. Sus derechos
Acceso, rectificación, supresión, oposición, portabilidad, retirar consentimiento.

5. Seguridad de datos
Medidas técnicas y organizativas.

6. Retención
Mientras sea necesario o por ley.

7. Cambios
Notificación en plataforma.

8. Contacto
nutrismartcontacto@gmail.com

Fecha de actualización: 13 de Mayo de 2025.
''';

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
        final createdUser = await _authService.register(user);

        // ✅ Guardar el usuario en UserService y en SharedPreferences
        await UserService().setUser(createdUser.toJson());

        if (_role == 'NUTRICIONIST') {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/startObjectives');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar usuario')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar los Términos y la Política de Privacidad')),
      );
    }
  }

  void _showModal(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        scrollable: true,
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar'))
        ],
      ),
    );
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
                      const Text('Crear Cuenta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nombre'),
                        validator: (value) => value == null || value.isEmpty ? 'El nombre es requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(labelText: 'Apellido'),
                        validator: (value) => value == null || value.isEmpty ? 'El apellido es requerido' : null,
                      ),
                      const SizedBox(height: 12),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingrese una contraseña';
                          if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(labelText: 'Confirmar Contraseña'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Confirme la contraseña';
                          if (value != _passwordController.text) return 'Las contraseñas no coinciden';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField(
                        value: _role,
                        items: const [
                          DropdownMenuItem(value: 'USER', child: Text('Cliente')),
                          DropdownMenuItem(value: 'NUTRICIONIST', child: Text('Nutricionista')),
                        ],
                        onChanged: (value) => setState(() => _role = value!),
                        decoration: const InputDecoration(labelText: 'Registrarse como'),
                      ),
                      CheckboxListTile(
                        title: Wrap(
                          children: [
                            const Text('Acepto los '),
                            GestureDetector(
                              onTap: () => _showModal('Términos y Condiciones', termsText),
                              child: const Text(
                                'Términos y Condiciones',
                                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                        value: _termsAccepted,
                        onChanged: (val) => setState(() => _termsAccepted = val!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        title: Wrap(
                          children: [
                            const Text('Acepto la '),
                            GestureDetector(
                              onTap: () => _showModal('Política de Privacidad', privacyText),
                              child: const Text(
                                'Política de Privacidad',
                                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                        value: _privacyAccepted,
                        onChanged: (val) => setState(() => _privacyAccepted = val!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Registrarse', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text('¿Ya tienes cuenta? Inicia sesión aquí'),
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