import 'package:flutter/material.dart';
import 'package:trabajoexp/services/customer_service.dart';
import 'package:trabajoexp/model/customer_model.dart';
import 'package:trabajoexp/model/objetive_data.dart';

class SetObjectives5Screen extends StatelessWidget {
  const SetObjectives5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> selectDiet(String diet) async {
      try {
        ObjectiveData.instance.dietaPreferida = diet;

        final userId = 1; // ⚡ Cambia por tu lógica real (auth o user service)

        final request = CustomerRequest.fromObjectiveData(ObjectiveData.instance);
        await CustomerService().createCustomer(userId, request);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("¡Objetivos guardados y enviados!")),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al guardar: $e")),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Paso 5 de 5")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("¿Qué tipo de dieta prefieres?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("No te preocupes, luego lo puedes cambiar."),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildDietButton("Recomendada", "recomendada", selectDiet),
                  _buildDietButton("Alta en Proteínas", "alta_proteinas", selectDiet),
                  _buildDietButton("Baja en Carbohidratos", "baja_carbohidratos", selectDiet),
                  _buildDietButton("Keto", "keto", selectDiet),
                  _buildDietButton("Baja en Grasas", "baja_grasas", selectDiet),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietButton(String title, String value, Function(String) onTap) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.check),
        onTap: () => onTap(value),
      ),
    );
  }
}