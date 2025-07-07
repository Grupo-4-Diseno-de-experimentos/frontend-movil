import 'package:flutter/material.dart';
import 'package:trabajoexp/model/recipe_model.dart';
import 'package:trabajoexp/services/recipe_service.dart';
import 'package:trabajoexp/screens/create_recipe_screen.dart';
import 'package:trabajoexp/widgets/app_side_bar_widget.dart';
import 'package:trabajoexp/services/user_service.dart';
import 'package:trabajoexp/screens/recipe_detail_screen.dart'; // ✅ Importa pantalla de detalle

class RecipeListScreen extends StatefulWidget {
  final bool isNutricionist;

  const RecipeListScreen({super.key, this.isNutricionist = true});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late Future<List<Recipe>> recipesFuture;

  @override
  void initState() {
    super.initState();
    recipesFuture = loadRecipesWithIngredients();
  }

  Future<List<Recipe>> loadRecipesWithIngredients() async {
    final recipes = await RecipeService().getRecipes();
    for (var recipe in recipes) {
      final ingredients = await RecipeService().getIngredientsByIds(recipe.ingredientsIds);
      recipe.ingredients = ingredients;
    }
    return recipes;
  }

  Future<void> goToCreateRecipe() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateRecipeScreen()),
    );
    setState(() {
      recipesFuture = loadRecipesWithIngredients();
    });
  }

  void addFavorite(Recipe recipe) async {
    final userId = UserService().getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe iniciar sesión para añadir a favoritos')),
      );
      return;
    }

    try {
      await RecipeService().addFavorite(userId, recipe.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${recipe.title} añadido a favoritos')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al añadir a favoritos')),
      );
    }
  }

  void goToRecipeDetail(Recipe recipe) async {
    final userId = UserService().getUserId() ?? 0;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailScreen(
          recipe: recipe,
          userId: userId,
        ),
      ),
    );
    // Si quieres refrescar la lista después de volver
    setState(() {
      recipesFuture = loadRecipesWithIngredients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Recetas')),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            if (widget.isNutricionist)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: goToCreateRecipe,
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir Receta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Recipe>>(
                future: recipesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final recipes = snapshot.data!;
                  if (recipes.isEmpty) {
                    return const Center(child: Text('No hay recetas disponibles.'));
                  }

                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () => goToRecipeDetail(recipe), // ✅ Tap para ver detalle
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(recipe.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                subtitle: Text(recipe.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                                child: Text(recipe.instructions, maxLines: 3, overflow: TextOverflow.ellipsis),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                                child: Text('Calorías: ${recipe.calories} Kcal', style: const TextStyle(fontWeight: FontWeight.w500)),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => addFavorite(recipe),
                                    icon: const Icon(Icons.favorite, color: Colors.red),
                                    label: const Text('Añadir a Favoritos'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}