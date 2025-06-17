import 'package:flutter/material.dart';
import 'package:trabajoexp/model/recipe_model.dart';
import 'package:trabajoexp/services/recipe_service.dart';


class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});
  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late Future<List<Recipe>> recipesFuture;

  @override
  void initState() {
    super.initState();
    recipesFuture = RecipeService().getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recetas')),
      body: FutureBuilder<List<Recipe>>(
        future: recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final recipes = snapshot.data!;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                child: ExpansionTile(
                  title: Text(recipe.title),
                  subtitle: Text("Calorías: ${recipe.calories}"),
                  children: [
                    Text("Carbs: ${recipe.macros.carbs}g | Proteínas: ${recipe.macros.protein}g | Grasas: ${recipe.macros.fats}g"),
                    SizedBox(height: 8),
                    Text("Ingredientes:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...recipe.ingredients.map((ing) => ListTile(
                      title: Text(ing.name),
                      subtitle: Text("${ing.quantity}g - ${ing.calories} cal"),
                    )),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}