class MealPlan {
  final int? id;
  final String name;
  final String category;
  final String description;
  final String goal;
  final double minBmi;
  final double maxBmi;
  final int minAge;
  final int maxAge;
  final int caloriesPerDay;
  final int? nutricionistId;

  MealPlan({
    this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.goal,
    required this.minBmi,
    required this.maxBmi,
    required this.minAge,
    required this.maxAge,
    required this.caloriesPerDay,
    required this.nutricionistId,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      goal: json['goal'],
      minBmi: json['min_bmi']?.toDouble() ?? 0.0,
      maxBmi: json['max_bmi']?.toDouble() ?? 0.0,
      minAge: json['min_age'] ?? 0,
      maxAge: json['max_age'] ?? 0,
      caloriesPerDay: json['calories_per_d'] ?? 0,
      nutricionistId: json['nutricionist_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'goal': goal,
      'min_bmi': minBmi,
      'max_bmi': maxBmi,
      'min_age': minAge,
      'max_age': maxAge,
      'calories_per_d': caloriesPerDay,
      'nutricionist_id': nutricionistId,
    };
  }
}