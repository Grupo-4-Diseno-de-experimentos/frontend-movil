import 'package:flutter/material.dart';
import 'package:trabajoexp/utils/create_meal_plan_request.dart';
import 'package:trabajoexp/services/meal_plan_service.dart';
import 'package:trabajoexp/services/recipe_service.dart';
import 'package:trabajoexp/model/recipe_model.dart';
import 'package:trabajoexp/screens/meal_plan_list_screen.dart';

class CreateMealPlanScreen extends StatefulWidget {
  const CreateMealPlanScreen({super.key});

  @override
  State<CreateMealPlanScreen> createState() => _CreateMealPlanScreenState();
}

class _CreateMealPlanScreenState extends State<CreateMealPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Recipe> _availableRecipes = [];
  bool _isLoadingRecipes = true;
  final RecipeService _recipeService = RecipeService();

  // Campos del plan
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _minBmiController = TextEditingController();
  final TextEditingController _maxBmiController = TextEditingController();
  final TextEditingController _minAgeController = TextEditingController();
  final TextEditingController _maxAgeController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  String? _selectedGoal;

  // Comidas por día (lunes a domingo)
  final List<String> _daysOfWeek = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];
  final Map<String, List<Map<String, dynamic>>> _mealsByDay = {};

  final Map<String, String> _goalOptions = {
    'Perdida de peso': 'PerdidaDePeso',
    'Ganar masa muscular': 'GanarMasaMuscular',
    'Mantenimiento': 'Mantenimiento',
  };

  final Map<String, String> _mealtimeOptions = {
    'Desayuno': 'Desayuno',
    'Almuerzo': 'Almuerzo',
    'Cena': 'Cena',
  };



  @override
  void initState() {
    super.initState();
    for (var day in _daysOfWeek) {
      _mealsByDay[day] = [];
    }
    _recipeService.getRecipes().then((recipes) {
      setState(() {
        _availableRecipes = recipes;
        _isLoadingRecipes = false;
      });
    }).catchError((e) {
      print("Error al cargar recetas: $e");
      setState(() => _isLoadingRecipes = false);
    });
  }

  void _addMeal(String day) {
    setState(() {
      _mealsByDay[day]!.add({
        'mealtime': null,
        'recipeId': null,
      });
    });
  }

  void _removeMeal(String day, int index) {
    setState(() {
      _mealsByDay[day]!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear nuevo plan de comida")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Datos del Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 10),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nombre del Plan')),

              TextFormField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Categoría')),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Meta del Plan'),
                value: _selectedGoal,
                items: _goalOptions.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value, // valor que se enviará
                    child: Text(entry.key), // texto visible
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedGoal = value),
              ),

              TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Descripción')),

              Row(children: [
                Expanded(child: TextFormField(controller: _minBmiController, decoration: const InputDecoration(labelText: 'IMC Mínimo'))),
                const SizedBox(width: 10),
                Expanded(child: TextFormField(controller: _maxBmiController, decoration: const InputDecoration(labelText: 'IMC Máximo'))),
              ]),

              Row(children: [
                Expanded(child: TextFormField(controller: _minAgeController, decoration: const InputDecoration(labelText: 'Edad Mínima'))),
                const SizedBox(width: 10),
                Expanded(child: TextFormField(controller: _maxAgeController, decoration: const InputDecoration(labelText: 'Edad Máxima'))),
              ]),

              TextFormField(controller: _caloriesController, decoration: const InputDecoration(labelText: 'Calorías por día')),

              const SizedBox(height: 24),
              const Text("Agregar comidas al plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 10),
              ..._daysOfWeek.map((day) => _buildDaySection(day)),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí puedes construir el objeto y enviarlo al backend
                    final plan = CreateMealPlanRequest(
                      name: _nameController.text,
                      category: _categoryController.text,
                      description: _descriptionController.text,
                      goal: _selectedGoal ?? '',
                      minBmi: double.tryParse(_minBmiController.text) ?? 0,
                      maxBmi: double.tryParse(_maxBmiController.text) ?? 0,
                      minAge: int.tryParse(_minAgeController.text) ?? 0,
                      maxAge: int.tryParse(_maxAgeController.text) ?? 0,
                      caloriesPerDay: int.tryParse(_caloriesController.text) ?? 0,
                      recipesByDay: _daysOfWeek.map((day) {
                        final meals = _mealsByDay[day]!
                            .where((m) => m['mealtime'] != null && m['recipeId'] != null)
                            .map((meal) => MealTimeEntry(
                          mealTime: meal['mealtime'],
                          recipeId: meal['recipeId'],
                        ))
                            .toList();
                        return RecipesByDay(day: day, meals: meals);
                      }).toList(),
                    );

                    MealPlanService().createFullMealPlan(plan).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Plan de comida creado correctamente')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MealPlanScreen()),
                      );
                    }).catchError((error) {
                      print('Error: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error al crear el plan')),
                      );
                    });
                  }
                },
                child: const Text("Guardar Plan"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaySection(String day) {
    final meals = _mealsByDay[day]!;

    return ExpansionTile(
      title: Text(day),
      subtitle: Text("${meals.length} comidas agregadas"),
      children: [
        ...meals.asMap().entries.map((entry) {
          final index = entry.key;
          final meal = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: meal['mealtime'],
                    hint: const Text("Tipo de comida"),
                    items: _mealtimeOptions.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.value,
                        child: Text(entry.key),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _mealsByDay[day]![index]['mealtime'] = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: meal['recipeId'],
                    hint: const Text("Receta"),
                    items: _availableRecipes.map((recipe) {
                      return DropdownMenuItem<int>(
                        value: recipe.id,
                        child: Text(recipe.title),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _mealsByDay[day]![index]['recipeId'] = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeMeal(day, index),
                ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => _addMeal(day),
          icon: const Icon(Icons.add),
          label: const Text("Agregar comida"),
        ),
      ],
    );
  }
}