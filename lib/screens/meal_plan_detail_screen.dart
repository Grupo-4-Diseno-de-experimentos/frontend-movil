import 'package:flutter/material.dart';
import 'package:trabajoexp/model/meal_plan_model.dart';
import 'package:trabajoexp/services/meal_plan_service.dart';
import 'package:trabajoexp/model/recipe_model.dart';

class MealPlanDetailScreen extends StatefulWidget {
  final int planId;

  const MealPlanDetailScreen({super.key, required this.planId});

  @override
  State<MealPlanDetailScreen> createState() => _MealPlanDetailScreenState();
}

class _MealPlanDetailScreenState extends State<MealPlanDetailScreen> {
  MealPlan? mealPlan;
  List<MealPlanRecipe> mealPlanRecipes = [];
  List<Recipe> recipesByPlanId = [];
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
      // Puedes traer recetas completas si quieres más detalles
      // final fullRecipes = await RecipeService().getRecipes(); y filtrarlos

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
      appBar: AppBar(title: const Text('Detalles del Plan de Comidas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlanInfo(),
            const SizedBox(height: 16),
            _buildScheduledRecipes(),
            const SizedBox(height: 16),
            _buildAllRecipes(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mealPlan!.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(mealPlan!.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledRecipes() {
    if (mealPlanRecipes.isEmpty) {
      return const Text('No hay recetas programadas.', style: TextStyle(fontSize: 16));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recetas Programadas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mealPlanRecipes.length,
          itemBuilder: (context, index) {
            final recipeDay = mealPlanRecipes[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.green),
                title: Text('${recipeDay.day} - ${recipeDay.mealTime}', style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/recipe/detail', arguments: recipeDay.recipe.id);
                  },
                  child: const Text('👁️ Ver Detalles'),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAllRecipes() {
    // Aquí podrías mostrar todas las recetas disponibles relacionadas al plan
    // O traerlas de RecipeService si lo deseas
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recetas Disponibles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Aquí podrías mostrar una lista de todas las recetas asociadas al plan si lo deseas.'),
      ],
    );
  }
}