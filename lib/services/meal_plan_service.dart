import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trabajoexp/model/meal_plan_model.dart';
import 'package:trabajoexp/enviroments/env.dart';

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
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return MealPlan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar el plan');
    }
  }

  Future<void> createMealPlan(MealPlan plan) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.51:8080/mealPlaner'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(plan.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear el plan');
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