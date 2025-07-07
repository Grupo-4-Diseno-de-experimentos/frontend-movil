import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trabajoexp/model/meal_plan_model.dart';
import 'package:trabajoexp/enviroments/env.dart';
import 'package:trabajoexp/utils/create_meal_plan_request.dart';

class MealPlanService {
  final String baseUrl = Env.baseUrl;

  Future<List<MealPlan>> getAllMealPlans({String? category, String? goal}) async {
    final queryParams = <String, String>{};

    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (goal != null && goal.isNotEmpty) {
      queryParams['goal'] = goal;
    }

    final uri = Uri.parse('$baseUrl/mealPlaner').replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => MealPlan.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load meal plans');
    }
  }

  Future<MealPlan> getMealPlanById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/mealPlaner/$id'));
    print('Respuesta mealplan: ${response.body}');
    if (response.statusCode == 200) {
      return MealPlan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar el plan');
    }
  }

  Future<void> createFullMealPlan(CreateMealPlanRequest plan) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mealPlanRecipes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(plan.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear el plan de comida');
    }
  }

  Future<List<MealPlanRecipe>> getMealPlanRecipesByPlanId(int planId) async {
    final response = await http.get(Uri.parse('$baseUrl/mealPlanRecipes/$planId'));
    print('Respuesta recipes: ${response.body}');
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded.map((e) => MealPlanRecipe.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Error al cargar recetas del plan');
    }
  }

  Future<List<MealPlan>> getCustomerMealPlans(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/customer_meal_plan'));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body
          .map((e) => MealPlan.fromJson(e))
          .toList();
    } else {
      throw Exception('Error al cargar los planes del cliente');
    }
  }
}