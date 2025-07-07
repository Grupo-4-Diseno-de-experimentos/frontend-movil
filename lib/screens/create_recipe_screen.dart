import 'package:flutter/material.dart';
import 'package:trabajoexp/model/recipe_model.dart';
import 'package:trabajoexp/services/recipe_service.dart';

class CreateRecipeScreen extends StatefulWidget {
  final Recipe? recipe; // ✅ Ahora acepta una receta opcional

  const CreateRecipeScreen({super.key, this.recipe});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores básicos
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final instructionsController = TextEditingController();
  final caloriesController = TextEditingController();
  final carbsController = TextEditingController();
  final proteinController = TextEditingController();
  final fatsController = TextEditingController();

  // Ingredientes
  List<Ingredient> allIngredients = [];
  List<Ingredient> filteredIngredients = [];
  List<Ingredient> selectedIngredients = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadIngredients();

    if (widget.recipe != null) {
      final r = widget.recipe!;
      titleController.text = r.title;
      descriptionController.text = r.description;
      instructionsController.text = r.instructions;
      caloriesController.text = r.calories.toString();
      carbsController.text = r.macros.carbs.toString();
      proteinController.text = r.macros.protein.toString();
      fatsController.text = r.macros.fats.toString();
      selectedIngredients = List<Ingredient>.from(r.ingredients);
    }
  }

  Future<void> loadIngredients() async {
    final ingredients = await RecipeService().getAllIngredients();
    setState(() {
      allIngredients = ingredients;
    });
  }

  void searchIngredients(String query) {
    setState(() {
      searchQuery = query;
      filteredIngredients = allIngredients
          .where((ing) => ing.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void addIngredient(Ingredient ingredient) {
    if (!selectedIngredients.contains(ingredient)) {
      setState(() {
        selectedIngredients.add(ingredient);
        filteredIngredients = [];
        searchQuery = '';
      });
    }
  }

  void removeIngredient(Ingredient ingredient) {
    setState(() {
      selectedIngredients.remove(ingredient);
    });
  }

  void submitRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    final newRecipe = Recipe(
      id: widget.recipe?.id ?? 0, // ✅ Si viene de edición, mantenemos id
      title: titleController.text,
      description: descriptionController.text,
      instructions: instructionsController.text,
      calories: int.parse(caloriesController.text),
      nutricionistId: 0, // pon tu ID real si lo usas
      macros: Macros(
        carbs: double.parse(carbsController.text),
        protein: double.parse(proteinController.text),
        fats: double.parse(fatsController.text),
      ),
      ingredientsIds: selectedIngredients.map((e) => e.id).toList(),
      ingredients: selectedIngredients,
    );

    try {
      await RecipeService().saveRecipe(newRecipe);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error al guardar receta: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar la receta')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.recipe != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Receta' : 'Crear Nueva Receta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionHeader(Icons.info_outline, 'Información Básica'),
              const SizedBox(height: 12),
              textField(titleController, 'Título*', 'Ej: Ensalada César', validator: (v) => v!.isEmpty ? 'Requerido' : null),
              const SizedBox(height: 12),
              textField(descriptionController, 'Descripción', 'Breve descripción...', lines: 3),
              const SizedBox(height: 12),
              textField(instructionsController, 'Instrucciones*', 'Describe paso a paso...', lines: 6, validator: (v) => v!.isEmpty ? 'Requerido' : null),

              const SizedBox(height: 24),
              sectionHeader(Icons.local_dining, 'Información Nutricional'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: numericField(caloriesController, 'Calorías*')),
                  const SizedBox(width: 8),
                  Expanded(child: numericField(carbsController, 'Carbs*')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: numericField(proteinController, 'Proteínas*')),
                  const SizedBox(width: 8),
                  Expanded(child: numericField(fatsController, 'Grasas*')),
                ],
              ),

              const SizedBox(height: 24),
              sectionHeader(Icons.shopping_cart, 'Ingredientes'),
              const SizedBox(height: 12),
              TextField(
                onChanged: searchIngredients,
                decoration: InputDecoration(
                  labelText: 'Buscar ingredientes...',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              if (filteredIngredients.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = filteredIngredients[index];
                      return ListTile(
                        title: Text(ingredient.name),
                        subtitle: Text('${ingredient.calories} kcal / 100g'),
                        onTap: () => addIngredient(ingredient),
                      );
                    },
                  ),
                ),

              if (selectedIngredients.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Text('Ingredientes seleccionados:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...selectedIngredients.map(
                          (ingredient) => Card(
                        child: ListTile(
                          title: Text(ingredient.name),
                          subtitle: Text(ingredient.category),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeIngredient(ingredient),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: submitRecipe,
                    icon: Icon(isEdit ? Icons.save_as : Icons.save),
                    label: Text(isEdit ? 'Actualizar Receta' : 'Guardar Receta'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget textField(TextEditingController controller, String label, String hint,
      {int lines = 1, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: lines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget numericField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (v) => v!.isEmpty ? 'Requerido' : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}