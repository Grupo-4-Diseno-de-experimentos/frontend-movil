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
  final RecipeService _recipeService = RecipeService();

  List<Recipe> _availableRecipes = [];
  bool _isLoadingRecipes = true;

  // Controllers
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _minBmiController = TextEditingController();
  final _maxBmiController = TextEditingController();
  final _minAgeController = TextEditingController();
  final _maxAgeController = TextEditingController();
  final _caloriesController = TextEditingController();

  String? _selectedGoal;

  final List<String> _daysOfWeek = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
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
      _mealsByDay[day]!.add({'mealtime': null, 'recipeId': null});
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
      body: _isLoadingRecipes
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildSectionCard(
                icon: Icons.restaurant_menu,
                title: "Datos del Plan",
                child: Column(
                  children: [
                    _buildInput(_nameController, "Nombre del Plan"),
                    _buildInput(_categoryController, "Categoría"),
                    _buildDropdown("Meta del Plan", _selectedGoal, _goalOptions, (value) => setState(() => _selectedGoal = value)),
                    _buildInput(_descriptionController, "Descripción"),
                    Row(children: [
                      Expanded(child: _buildInput(_minBmiController, "IMC Mínimo", isNumber: true)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildInput(_maxBmiController, "IMC Máximo", isNumber: true)),
                    ]),
                    Row(children: [
                      Expanded(child: _buildInput(_minAgeController, "Edad Mínima", isNumber: true)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildInput(_maxAgeController, "Edad Máxima", isNumber: true)),
                    ]),
                    _buildInput(_caloriesController, "Calorías por día", isNumber: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                icon: Icons.calendar_month,
                title: "Agregar comidas al plan",
                child: Column(children: _daysOfWeek.map((day) => _buildDaySection(day)).toList()),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text("Guardar Plan"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _savePlan,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required IconData icon, required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFFEBF8FF), Color(0xFFE0F2FE)]),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(children: [
            Icon(icon, color: Colors.blue.shade700),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, Map<String, String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: options.entries.map((entry) => DropdownMenuItem(value: entry.value, child: Text(entry.key))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDaySection(String day) {
    final meals = _mealsByDay[day]!;

    return ExpansionTile(
      title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("${meals.length} comidas agregadas"),
      children: [
        ...meals.asMap().entries.map((entry) {
          final index = entry.key;
          final meal = entry.value;
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: meal['mealtime'],
                  decoration: const InputDecoration(labelText: "Tipo de comida"),
                  items: _mealtimeOptions.entries.map((e) => DropdownMenuItem(value: e.value, child: Text(e.key))).toList(),
                  onChanged: (value) => setState(() => _mealsByDay[day]![index]['mealtime'] = value),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: meal['recipeId'],
                  decoration: const InputDecoration(labelText: "Receta"),
                  items: _availableRecipes.map((recipe) => DropdownMenuItem(value: recipe.id, child: Text(recipe.title))).toList(),
                  onChanged: (value) => setState(() => _mealsByDay[day]![index]['recipeId'] = value),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeMeal(day, index),
              )
            ],
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

  void _savePlan() {
    if (_formKey.currentState!.validate()) {
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
              .map((meal) => MealTimeEntry(mealTime: meal['mealtime'], recipeId: meal['recipeId']))
              .toList();
          return RecipesByDay(day: day, meals: meals);
        }).toList(),
      );

      MealPlanService().createFullMealPlan(plan).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan creado exitosamente')));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MealPlanScreen()));
      }).catchError((error) {
        print("Error: $error");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al crear el plan')));
      });
    }
  }
}