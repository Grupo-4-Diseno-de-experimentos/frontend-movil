import 'package:flutter/material.dart';
import 'package:trabajoexp/model/recipe_model.dart';
import 'package:trabajoexp/services/recipe_service.dart';
import 'package:trabajoexp/widgets/app_side_bar_widget.dart'; // ✅ Importa tu widget de sidebar

class FavoriteRecipeScreen extends StatefulWidget {
  final int userId;

  const FavoriteRecipeScreen({super.key, required this.userId});

  @override
  State<FavoriteRecipeScreen> createState() => _FavoriteRecipeScreenState();
}

class _FavoriteRecipeScreenState extends State<FavoriteRecipeScreen> {
  late Future<List<Recipe>> favoritesFuture;

  @override
  void initState() {
    super.initState();
    favoritesFuture = RecipeService().getFavoriteRecipesByUserId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tus Recetas Favoritas')),
      drawer: const AppSidebar(), // ✅ Aquí agregamos el sidebar
      body: FutureBuilder<List<Recipe>>(
        future: favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final recipes = snapshot.data ?? [];
          if (recipes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aún no tienes recetas favoritas guardadas.', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // Cambia a 2 o 3 si quieres columnas en pantallas grandes
              childAspectRatio: 1.4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${recipe.calories} kcal', style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(recipe.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Text('Carbs: ${recipe.macros.carbs}g | Prot: ${recipe.macros.protein}g | Fat: ${recipe.macros.fats}g', style: const TextStyle(fontSize: 13)),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/recipe/detail',
                                arguments: {
                                  'recipe': recipe,
                                  'userId': widget.userId,
                                  'isNutricionist': true,
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            child: const Text('Ver Detalle'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}