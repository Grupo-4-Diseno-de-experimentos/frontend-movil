class Ingredient {
  final int id;
  final String name;
  final double quantity;
  final double calories;
  final double carbs;
  final double protein;
  final double fats;
  final String category;
  final bool available;

  Ingredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fats,
    required this.category,
    required this.available,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      quantity: (json['quantity'] ?? 0).toDouble(),
      calories: (json['calories'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
      category: json['category'],
      available: json['available'],
    );
  }
}

class Macros {
  final double carbs;
  final double protein;
  final double fats;

  Macros({
    required this.carbs,
    required this.protein,
    required this.fats,
  });

  factory Macros.fromJson(Map<String, dynamic> json) {
    return Macros(
      carbs: (json['carbs'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
    );
  }
}

class Recipe {
  final int id;
  final String title;
  final String description;
  final String instructions;
  final int calories;
  final int nutricionistId;
  final Macros macros;
  final List<Ingredient> ingredients;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.instructions,
    required this.calories,
    required this.nutricionistId,
    required this.macros,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructions: json['instructions'],
      calories: json['calories'],
      nutricionistId: json['nutricionist_id'],
      macros: Macros.fromJson(json['macros']),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e))
          .toList(),
    );
  }
}