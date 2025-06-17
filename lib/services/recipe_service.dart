import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trabajoexp/model/recipe_model.dart';
import 'package:trabajoexp/enviroments/env.dart';

class RecipeService{
  final String baseUrl = Env.baseUrl;

  Future<List<Recipe>> getRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl/recipe'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      List<Recipe> recipes = [];

      for (var recipeData in data) {
        final ingredientsResponse = await http.get(Uri.parse('$baseUrl/ingredients/recipe/${recipeData["id"]}'));
        final ingredientsData = json.decode(ingredientsResponse.body) as List;
        recipeData['ingredients'] = ingredientsData;

        recipes.add(Recipe.fromJson(recipeData));
      }

      return recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}