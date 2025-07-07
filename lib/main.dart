import 'package:flutter/material.dart';
import 'package:trabajoexp/screens/dashboard_screen.dart';
import 'package:trabajoexp/screens/meal_plan_list_screen.dart';
import 'package:trabajoexp/screens/register_screen.dart';
import 'package:trabajoexp/screens/login_screen.dart';
import 'package:trabajoexp/screens/recipe_detail_screen.dart';
import 'package:trabajoexp/screens/start_objectives_screen.dart';
import 'package:trabajoexp/services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserService().init();
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
        '/dashboard': (context) => const DashboardScreen(),
        '/startObjectives': (context) => const StartObjectivesScreen(), // ✅ Agrega aquí

        '/recipe/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return RecipeDetailScreen(
            recipe: args['recipe'],
            userId: args['userId'],
            isNutricionist: args['isNutricionist'] ?? true,
          );
        },
      },
    );
  }
}

