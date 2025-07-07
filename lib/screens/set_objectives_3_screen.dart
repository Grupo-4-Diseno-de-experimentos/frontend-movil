import 'package:flutter/material.dart';
import 'set_objectives_4_screen.dart';
import 'package:trabajoexp/model/customer_model.dart';
import 'package:trabajoexp/model/objetive_data.dart';

class SetObjectives3Screen extends StatefulWidget {
  const SetObjectives3Screen({super.key});

  @override
  State<SetObjectives3Screen> createState() => _SetObjectives3ScreenState();
}

class _SetObjectives3ScreenState extends State<SetObjectives3Screen> {
  final _formKey = GlobalKey<FormState>();
  String? sexo;
  int? edad;
  double? altura;
  double? peso;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paso 3 de 5")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Sobre ti",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Sexo"),
                items: const [
                  DropdownMenuItem(value: "hombre", child: Text("Hombre")),
                  DropdownMenuItem(value: "mujer", child: Text("Mujer")),
                  DropdownMenuItem(value: "otro", child: Text("Otro")),
                ],
                onChanged: (value) => sexo = value,
                validator: (value) => value == null ? "Seleccione su sexo" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Edad (años)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final numValue = int.tryParse(value ?? '');
                  if (numValue == null || numValue < 10 || numValue > 100) {
                    return "Edad válida (10-100)";
                  }
                  return null;
                },
                onSaved: (value) => edad = int.tryParse(value ?? ''),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Altura (cm)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final numValue = double.tryParse(value ?? '');
                  if (numValue == null || numValue < 100 || numValue > 250) {
                    return "Altura válida (100-250)";
                  }
                  return null;
                },
                onSaved: (value) => altura = double.tryParse(value ?? ''),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Peso (kg)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final numValue = double.tryParse(value ?? '');
                  if (numValue == null || numValue < 30 || numValue > 300) {
                    return "Peso válido (30-300)";
                  }
                  return null;
                },
                onSaved: (value) => peso = double.tryParse(value ?? ''),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ObjectiveData.instance.sexo = sexo;
                    ObjectiveData.instance.edad = edad;
                    ObjectiveData.instance.altura = altura;
                    ObjectiveData.instance.peso = peso;
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SetObjectives4Screen()));
                  }
                },
                child: const Text("Continuar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}