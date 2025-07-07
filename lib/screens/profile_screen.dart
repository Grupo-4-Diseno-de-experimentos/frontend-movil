import 'package:flutter/material.dart';
import 'package:trabajoexp/model/objetive_data.dart';
import 'package:trabajoexp/services/user_service.dart';
import 'package:trabajoexp/widgets/app_side_bar_widget.dart';
import 'package:trabajoexp/services/objective_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Datos del usuario
  String name = "";
  String lastName = "";
  String email = "";
  String sexo = "";
  int edad = 0;
  double altura = 0;
  double peso = 0;

  // Datos de objetivos
  ObjectiveData objectives = ObjectiveData.instance;

  bool isEditingProfile = false;

  // Variables temporales para edición
  late String editedName;
  late String editedLastName;
  late String editedEmail;
  late String editedSexo;
  late int editedEdad;
  late double editedAltura;
  late double editedPeso;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadObjectives();
  }

  void _loadUserData() {
    final user = UserService().getUser();
    if (user != null) {
      setState(() {
        name = user['name'] ?? "";
        lastName = user['lastName'] ?? "";
        email = user['email'] ?? "";
        sexo = user['sexo'] ?? "No especificado";
        edad = user['edad'] ?? 0;
        altura = (user['altura'] ?? 0).toDouble();
        peso = (user['peso'] ?? 0).toDouble();

        editedName = name;
        editedLastName = lastName;
        editedEmail = email;
        editedSexo = sexo;
        editedEdad = edad;
        editedAltura = altura;
        editedPeso = peso;
      });
    }
  }

  void _loadObjectives() async {
    final loaded = await ObjectiveService().loadObjectives();

    setState(() {
      objectives.objetivoPrincipal = loaded.objetivoPrincipal;
      objectives.metodoPreferido = loaded.metodoPreferido;
      objectives.nivelActividad = loaded.nivelActividad;
      objectives.dietaPreferida = loaded.dietaPreferida;
      objectives.sexo = loaded.sexo;
      objectives.edad = loaded.edad;
      objectives.altura = loaded.altura;
      objectives.peso = loaded.peso;
    });
  }

  void saveProfileChanges() {
    setState(() {
      name = editedName;
      lastName = editedLastName;
      email = editedEmail;
      sexo = editedSexo;
      edad = editedEdad;
      altura = editedAltura;
      peso = editedPeso;
      isEditingProfile = false;

      // ✅ Actualizar en UserService y guardar
      final updatedUser = {
        'name': name,
        'lastName': lastName,
        'email': email,
        'sexo': sexo,
        'edad': edad,
        'altura': altura,
        'peso': peso,
        ...UserService().getUser() ?? {},
      };
      UserService().setUser(updatedUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),
      drawer: const AppSidebar(), // ✅ Sidebar integrado aquí
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Información Personal", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            _buildInfoRow("Nombre", "$name $lastName"),
            _buildInfoRow("Email", email),
            _buildInfoRow("Sexo", sexo),
            _buildInfoRow("Edad", edad > 0 ? "$edad años" : "No especificado"),
            _buildInfoRow("Altura", altura > 0 ? "$altura cm" : "No especificado"),
            _buildInfoRow("Peso", peso > 0 ? "$peso kg" : "No especificado"),
            ElevatedButton(
              onPressed: () => setState(() => isEditingProfile = true),
              child: const Text("Editar Perfil"),
            ),
            const Divider(height: 40),
            Text("Meta Personal", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            _buildObjectiveCard("Objetivo Principal", objectives.objetivoPrincipal ?? "No especificado", 'objetivoPrincipal'),
            _buildObjectiveCard("Método Preferido", objectives.metodoPreferido ?? "No especificado", 'metodoPreferido'),
            _buildObjectiveCard("Nivel Actividad", objectives.nivelActividad ?? "No especificado", 'nivelActividad'),
            _buildObjectiveCard("Dieta Preferida", objectives.dietaPreferida ?? "No especificado", 'dietaPreferida'),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomSheet: isEditingProfile ? _buildEditProfileModal(context) : null,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text("$label:")),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildObjectiveCard(String title, String value, String type) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title),
        subtitle: Text(getDisplayValue(value, type)),
      ),
    );
  }

  String getDisplayValue(String? value, String type) {
    if (value == null || value.isEmpty) return "No especificado";

    switch (type) {
      case 'objetivoPrincipal':
        return {
          'perder_grasa': "Perder Grasa",
          'ganar_musculo': "Ganar Músculo",
          'mantener_peso': "Mantener Peso"
        }[value] ?? value;
      case 'metodoPreferido':
        return {
          'plan_nutricional': "Necesito un plan nutricional",
          'contar_calorias': "Necesito contar mis calorías"
        }[value] ?? value;
      case 'nivelActividad':
        return {
          'sedentario': "Sedentario",
          'ligeramente_activo': "Ligeramente Activo",
          'moderadamente_activo': "Moderadamente Activo",
          'muy_activo': "Muy Activo",
          'atleta_profesional': "Atleta Profesional"
        }[value] ?? value;
      case 'dietaPreferida':
        return {
          'recomendada': "Recomendada",
          'alta_proteinas': "Alta en Proteínas",
          'baja_carbohidratos': "Baja en Carbohidratos",
          'keto': "Keto",
          'baja_grasas': "Baja en Grasas"
        }[value] ?? value;
      default:
        return value;
    }
  }

  Widget _buildEditProfileModal(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Editar Información Personal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextField(
              decoration: const InputDecoration(labelText: "Nombre"),
              onChanged: (v) => editedName = v,
              controller: TextEditingController(text: editedName),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Apellido"),
              onChanged: (v) => editedLastName = v,
              controller: TextEditingController(text: editedLastName),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Email"),
              onChanged: (v) => editedEmail = v,
              controller: TextEditingController(text: editedEmail),
            ),
            DropdownButtonFormField<String>(
              value: editedSexo,
              decoration: const InputDecoration(labelText: "Sexo"),
              items: const [
                DropdownMenuItem(value: "hombre", child: Text("Hombre")),
                DropdownMenuItem(value: "mujer", child: Text("Mujer")),
                DropdownMenuItem(value: "otro", child: Text("Otro")),
              ],
              onChanged: (v) => setState(() => editedSexo = v ?? "hombre"),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Edad"),
              keyboardType: TextInputType.number,
              onChanged: (v) => editedEdad = int.tryParse(v) ?? edad,
              controller: TextEditingController(text: "$editedEdad"),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Altura (cm)"),
              keyboardType: TextInputType.number,
              onChanged: (v) => editedAltura = double.tryParse(v) ?? altura,
              controller: TextEditingController(text: "$editedAltura"),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Peso (kg)"),
              keyboardType: TextInputType.number,
              onChanged: (v) => editedPeso = double.tryParse(v) ?? peso,
              controller: TextEditingController(text: "$editedPeso"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: saveProfileChanges, child: const Text("Guardar")),
                ElevatedButton(onPressed: () => setState(() => isEditingProfile = false), child: const Text("Cancelar")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}