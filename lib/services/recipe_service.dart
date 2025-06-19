import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trabajoexp/model/recipe_model.dart';
import 'package:trabajoexp/enviroments/env.dart';

class RecipeService{
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
}