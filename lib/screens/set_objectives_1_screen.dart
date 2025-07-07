import 'package:flutter/material.dart';
import 'set_objectives_2_screen.dart';
import 'package:trabajoexp/model/customer_model.dart';
import 'package:trabajoexp/model/objetive_data.dart';

class SetObjectives1Screen extends StatelessWidget {
  const SetObjectives1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    void selectGoal(String goal) {
      ObjectiveData.instance.objetivoPrincipal = goal;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SetObjectives2Screen()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Paso 1 de 5")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("¿Cuál es tu objetivo?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Calcularemos tus calorías necesarias para lograrlo."),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildGoalButton("Perder Grasa", "perder_grasa", selectGoal),
                  _buildGoalButton("Ganar Músculo", "ganar_musculo", selectGoal),
                  _buildGoalButton("Mantener Peso", "mantener_peso", selectGoal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalButton(String title, String value, Function(String) onTap) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => onTap(value),
      ),
    );
  }
}