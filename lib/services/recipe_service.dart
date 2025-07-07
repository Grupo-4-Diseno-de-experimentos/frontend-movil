import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trabajoexp/model/recipe_model.dart';
import 'package:trabajoexp/enviroments/env.dart';

class RecipeService {
  final String baseUrl = Env.baseUrl;

  Future<List<Recipe>> getRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl/recipe'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Recipe.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar recetas');
    }
  }

  Future<List<Ingredient>> getIngredientsByIds(List<int> ids) async {
    final response = await http.get(Uri.parse('$baseUrl/ingredients'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .where((i) => ids.contains(i['id']))
          .map((i) => Ingredient.fromJson(i))
          .toList();
    }
    return [];
  }

  Future<List<Recipe>> getFavoriteRecipesByUserId(int userId) async {
    final recipesResp = await http.get(Uri.parse('$baseUrl/recipe'));
    final favoritesResp = await http.get(Uri.parse('$baseUrl/favorite/$userId'));

    if (recipesResp.statusCode == 200 && favoritesResp.statusCode == 200) {
      final List<dynamic> recipesData = json.decode(recipesResp.body);
      final List<dynamic> favoritesData = json.decode(favoritesResp.body);

      final recipeEntities = recipesData.map((e) => Recipe.fromJson(e)).toList();
      final favoriteIds = favoritesData.map<int>((f) => f['recipeId']).toList();

      final filtered = recipeEntities.where((r) => favoriteIds.contains(r.id)).toList();
      return filtered;
    } else {
      throw Exception('Error al cargar favoritos');
    }
  }

  Future<void> addFavorite(int userId, int recipeId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/favorite'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'recipeId': recipeId,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al añadir a favoritos');
    }
  }

  Future<Recipe> saveRecipe(Recipe recipe) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recipe'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': recipe.title,
        'description': recipe.description,
        'instructions': recipe.instructions,
        'calories': recipe.calories,
        'nutricionist_id': recipe.nutricionistId,
        'macros': {
          'carbs': recipe.macros.carbs,
          'protein': recipe.macros.protein,
          'fats': recipe.macros.fats,
          'recipe_id': recipe.id,
        },
        'ingredientIds': recipe.ingredientsIds,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return Recipe.fromJson(data);
    } else {
      throw Exception('Error al guardar receta');
    }
  }

  Future<void> saveRecipeIngredients(List<Map<String, dynamic>> ingredients) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recipe_ingredients'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ingredients),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al guardar recipe_ingredients');
    }
  }
  Future<List<Ingredient>> getAllIngredients() async {
    final response = await http.get(Uri.parse('$baseUrl/ingredients'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Ingredient.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar ingredientes');
    }
  }
}