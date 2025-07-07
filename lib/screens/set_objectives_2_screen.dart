import 'package:flutter/material.dart';
import 'set_objectives_3_screen.dart';
import 'package:trabajoexp/model/customer_model.dart';
import 'package:trabajoexp/model/objetive_data.dart';

class SetObjectives2Screen extends StatelessWidget {
  const SetObjectives2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    void selectMethod(String method) {
      ObjectiveData.instance.metodoPreferido = method;
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SetObjectives3Screen()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Paso 2 de 5")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("¿Cómo deseas conseguirlo?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("No te preocupes, luego lo puedes cambiar."),
            const SizedBox(height: 20),
            _buildMethodButton("Necesito un plan nutricional", "plan_nutricional", selectMethod),
            _buildMethodButton("Necesito contar mis calorías", "contar_calorias", selectMethod),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodButton(String title, String value, Function(String) onTap) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => onTap(value),
      ),
    );
  }
}