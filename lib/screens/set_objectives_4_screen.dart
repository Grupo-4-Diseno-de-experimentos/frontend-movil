import 'package:flutter/material.dart';
import 'set_objectives_5_screen.dart';
import 'package:trabajoexp/model/objetive_data.dart';
import 'package:trabajoexp/model/customer_model.dart';

class SetObjectives4Screen extends StatelessWidget {
  const SetObjectives4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    void selectActivity(String activity) {
      ObjectiveData.instance.nivelActividad = activity;
      Navigator.push(context, MaterialPageRoute(builder: (_)  => const SetObjectives5Screen()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Paso 4 de 5")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("¿Cuál es tu nivel de actividad física?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("No te preocupes, luego lo puedes cambiar."),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildActivityButton("Sedentario", "sedentario", selectActivity),
                  _buildActivityButton("Ligeramente Activo", "ligeramente_activo", selectActivity),
                  _buildActivityButton("Moderadamente Activo", "moderadamente_activo", selectActivity),
                  _buildActivityButton("Muy Activo", "muy_activo", selectActivity),
                  _buildActivityButton("Atleta Profesional", "atleta_profesional", selectActivity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityButton(String title, String value, Function(String) onTap) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => onTap(value),
      ),
    );
  }
}