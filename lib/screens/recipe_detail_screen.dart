import 'package:flutter/material.dart';
import 'package:trabajoexp/model/recipe_model.dart';
import 'package:trabajoexp/screens/create_recipe_screen.dart';
import 'package:trabajoexp/services/recipe_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final int userId;
  final bool isNutricionist; // ✅ Añadido

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.userId,
    this.isNutricionist = true,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final RecipeService _recipeService = RecipeService();
  bool isFavorite = false;
  late Recipe currentRecipe;

  @override
  void initState() {
    super.initState();
    currentRecipe = widget.recipe;
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    try {
      final favorites = await _recipeService.getFavoriteRecipesByUserId(widget.userId);
      setState(() {
        isFavorite = favorites.any((r) => r.id == widget.recipe.id);
      });
    } catch (e) {
      print('Error al verificar favoritos: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      await _recipeService.addFavorite(widget.userId, widget.recipe.id);
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      print('Error al añadir favorito: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentRecipe.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentRecipe.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(currentRecipe.description),
            const SizedBox(height: 16),
            Text(
              "Instrucciones",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(currentRecipe.instructions),
            const SizedBox(height: 16),
            Text(
              "Calorías: ${currentRecipe.calories}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Macros: Carbs ${currentRecipe.macros.carbs}, Proteínas ${currentRecipe.macros.protein}, Grasas ${currentRecipe.macros.fats}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              "Ingredientes",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (currentRecipe.ingredients.isEmpty)
              const Text("No hay ingredientes asociados")
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentRecipe.ingredients.length,
                itemBuilder: (context, index) {
                  final ing = currentRecipe.ingredients[index];
                  return ListTile(
                    title: Text(ing.name),
                    subtitle: Text("Cantidad: ${ing.quantity}\n"
                        "Calorías: ${ing.calories}\n"
                        "Carbs: ${ing.carbs}, Proteínas: ${ing.protein}, Grasas: ${ing.fats}"),
                  );
                },
              ),
            const SizedBox(height: 24),

            // ✅ Botón Editar si es nutricionista
            if (widget.isNutricionist)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final updatedRecipe = await Navigator.push<Recipe>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateRecipeScreen(recipe: currentRecipe),
                      ),
                    );

                    // ✅ Si se devuelve la receta actualizada, actualizamos en pantalla
                    if (updatedRecipe != null) {
                      setState(() {
                        currentRecipe = updatedRecipe;
                      });
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar receta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}