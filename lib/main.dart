import 'package:flutter/material.dart';
import 'package:trabajoexp/screens/meal_plan_list_screen.dart';
import 'package:trabajoexp/screens/recipe_list_screen.dart';
import 'package:trabajoexp/screens/create_meal_plan_screen.dart';
import 'package:trabajoexp/screens/register_screen.dart';
import 'package:trabajoexp/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriSmart',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/mealplans': (context) => const MealPlanScreen(),
      },
    );
  }
}
