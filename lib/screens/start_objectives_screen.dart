import 'package:flutter/material.dart';
import 'set_objectives_1_screen.dart';

class StartObjectivesScreen extends StatelessWidget {
  const StartObjectivesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network("https://i.postimg.cc/jSNvxSfm/image.png", height: 180),
              const SizedBox(height: 20),
              const Text("Personaliza tus Objetivos",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Comienza a configurar tus metas de alimentación y bienestar. ¡Es fácil y rápido!",
                  textAlign: TextAlign.center),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SetObjectives1Screen()),
                  );
                },
                child: const Text("Comenzar Personalización"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}