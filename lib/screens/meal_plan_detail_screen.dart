import 'package:flutter/material.dart';
import 'package:trabajoexp/model/meal_plan_model.dart';
import 'package:trabajoexp/services/meal_plan_service.dart';
import 'package:trabajoexp/model/recipe_model.dart';
import 'package:trabajoexp/services/user_service.dart';

class MealPlanDetailScreen extends StatefulWidget {
  final int planId;

  const MealPlanDetailScreen({super.key, required this.planId});

  @override
  State<MealPlanDetailScreen> createState() => _MealPlanDetailScreenState();
}

class _MealPlanDetailScreenState extends State<MealPlanDetailScreen> {
  MealPlan? mealPlan;
  List<MealPlanRecipe> mealPlanRecipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMealPlanDetails();
  }

  Future<void> loadMealPlanDetails() async {
    try {
      final plan = await MealPlanService().getMealPlanById(widget.planId);
      final recipes = await MealPlanService().getMealPlanRecipesByPlanId(widget.planId);

      setState(() {
        mealPlan = plan;
        mealPlanRecipes = recipes;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (mealPlan == null) {
      return const Scaffold(body: Center(child: Text('No se encontró el plan.')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('🍽️ Detalles del Plan de Comidas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.green.shade100, blurRadius: 8, offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlanInfo(),
                  const SizedBox(height: 20),
                  _buildScheduledRecipes(),
                  const SizedBox(height: 20),
                  _buildAvailableRecipes(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text("ℹ️ ", style: TextStyle(fontSize: 24)),
            Text("Información del Plan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        const SizedBox(height: 12),
        Text("Título:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green.shade800)),
        Container(
          margin: const EdgeInsets.only(bottom: 10, top: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(mealPlan!.name),
        ),
        Text("Descripción:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green.shade800)),
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(mealPlan!.description),
        ),
      ],
    );
  }

  Widget _buildScheduledRecipes() {
    if (mealPlanRecipes.isEmpty) {
      return const Text('⏰ No hay recetas programadas.', style: TextStyle(fontSize: 16));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text("⏰ ", style: TextStyle(fontSize: 24)),
            Text("Recetas Programadas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        const SizedBox(height: 12),
        ...mealPlanRecipes.map((recipeDay) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.green.shade200, blurRadius: 5, offset: const Offset(0, 3))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("📅 ", style: TextStyle(fontSize: 20)),
                    Expanded(
                      child: Text("${recipeDay.day} - ${recipeDay.mealTime}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  recipeDay.recipe.title,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAvailableRecipes() {
    if (mealPlanRecipes.isEmpty) {
      return const Text('📖 No hay recetas disponibles.', style: TextStyle(fontSize: 16));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text("📖 ", style: TextStyle(fontSize: 24)),
            Text("Recetas Disponibles", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        const SizedBox(height: 12),
        ...mealPlanRecipes.map((recipeDay) {
          final recipe = recipeDay.recipe;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.green.shade200),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.green.shade100, blurRadius: 5, offset: const Offset(0, 3))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 6),
                Text(recipe.description, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 6),
                Text("🔥 ${recipe.calories} kcal", style: const TextStyle(fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      final userId = UserService().getUserId();
                      final isNutri = UserService().isNutricionist();

                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Usuario no identificado")),
                        );
                        return;
                      }

                      Navigator.pushNamed(
                        context,
                        '/recipe/detail',
                        arguments: {
                          'recipe': recipe,
                          'userId': userId,
                          'isNutricionist': isNutri,
                        },
                      );
                    },
                    child: const Text("👁️ Ver Detalles"),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}