import 'package:flutter/material.dart';
import 'package:trabajoexp/screens/dashboard_screen.dart';
import 'package:trabajoexp/screens/favorite_recipe_screen.dart';
import 'package:trabajoexp/screens/meal_plan_list_screen.dart';
import 'package:trabajoexp/screens/recipe_list_screen.dart';
import 'package:trabajoexp/services/user_service.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = UserService().getUserId();

    if (userId == null) {
      // Mostrar un placeholder o navegar a login
      return const Drawer(
        child: Center(child: Text("Usuario no autenticado")),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
            ),
            child: Text('NutriSmart', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Planes de Comida'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MealPlanScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Recetas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RecipeListScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favoritos'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteRecipeScreen(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
