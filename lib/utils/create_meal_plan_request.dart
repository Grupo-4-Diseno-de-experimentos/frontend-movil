class MealTimeEntry {
  final String mealTime;
  final int recipeId;

  MealTimeEntry({required this.mealTime, required this.recipeId});

  Map<String, dynamic> toJson() => {
    'meal_time': mealTime,
    'recipe_id': recipeId,
  };
}

class RecipesByDay {
  final String day;
  final List<MealTimeEntry> meals;

  RecipesByDay({required this.day, required this.meals});

  Map<String, dynamic> toJson() => {
    'day': day,
    'meals': meals.map((m) => m.toJson()).toList(),
  };
}

class CreateMealPlanRequest {
  final String name;
  final String category;
  final String description;
  final String goal;
  final double minBmi;
  final double maxBmi;
  final int minAge;
  final int maxAge;
  final int caloriesPerDay;
  final List<RecipesByDay> recipesByDay;

  CreateMealPlanRequest({
    required this.name,
    required this.category,
    required this.description,
    required this.goal,
    required this.minBmi,
    required this.maxBmi,
    required this.minAge,
    required this.maxAge,
    required this.caloriesPerDay,
    required this.recipesByDay,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'description': description,
    'goal': goal,
    'min_bmi': minBmi,
    'max_bmi': maxBmi,
    'min_age': minAge,
    'max_age': maxAge,
    'calories_per_d': caloriesPerDay,
    'recipesByDay': recipesByDay.map((d) => d.toJson()).toList(),
  };
}